<script>
	let output = $state([]);
	let copiedId = $state(null);
	let timeoutId = null;

	const CROCKFORD = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';
	const BASE62 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
	const NANO_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-';

	function generate() {
		const uuidV4 = crypto.randomUUID();
		const uuidBytes = hexToBytes(uuidV4.replace(/-/g, ''));

		output = [
			{ label: 'UUID v4 (Random)', value: uuidV4 },
			{ label: 'UUID v4 — No Dashes', value: uuidV4.replace(/-/g, '') },
			{ label: 'UUID v4 — UPPERCASE', value: uuidV4.toUpperCase() },
			{ label: 'UUID v7 (Time-ordered)', value: generateV7() },
			{ label: 'ULID (Crockford Base32)', value: generateUlid() },
			{ label: 'Nano ID (URL-safe)', value: generateNanoId() },
			{ label: 'Short UUID (Base62)', value: base62Encode(uuidBytes) }
		];
		copiedId = null;
	}

	function generateV7() {
		const timestamp = Date.now();
		const hex = timestamp.toString(16).padStart(12, '0');
		const random = Array.from(crypto.getRandomValues(new Uint8Array(10)), (b) =>
			b.toString(16).padStart(2, '0')
		).join('');
		const variant = ['8', '9', 'a', 'b'][crypto.getRandomValues(new Uint8Array(1))[0] & 3];
		return `${hex.slice(0, 8)}-${hex.slice(8, 12)}-7${random.slice(0, 3)}-${variant}${random.slice(3, 7)}-${random.slice(7, 15)}`;
	}

	function generateUlid() {
		let ts = Date.now();
		const buf = new Uint8Array(16);
		for (let i = 5; i >= 0; i--) {
			buf[i] = ts & 0xff;
			ts = Math.floor(ts / 256);
		}
		crypto.getRandomValues(buf.subarray(6));

		let ulid = '';
		let bits = 0;
		let buffer = 0;
		for (let i = 0; i < 16; i++) {
			buffer = (buffer << 8) | buf[i];
			bits += 8;
			while (bits >= 5) {
				bits -= 5;
				ulid += CROCKFORD[(buffer >> bits) & 0x1f];
			}
		}
		if (bits > 0) {
			ulid += CROCKFORD[(buffer << (5 - bits)) & 0x1f];
		}
		return ulid;
	}

	function generateNanoId() {
		const bytes = crypto.getRandomValues(new Uint8Array(21));
		return Array.from(bytes, (b) => NANO_CHARS[b % 64]).join('');
	}

	function hexToBytes(hex) {
		const bytes = new Uint8Array(16);
		for (let i = 0; i < 32; i += 2) {
			bytes[i / 2] = parseInt(hex.slice(i, i + 2), 16);
		}
		return bytes;
	}

	function base62Encode(bytes) {
		let value = 0n;
		for (let i = 0; i < bytes.length; i++) {
			value = (value << 8n) + BigInt(bytes[i]);
		}
		let result = '';
		while (value > 0n) {
			result = BASE62[Number(value % 62n)] + result;
			value /= 62n;
		}
		return result.padStart(22, '0');
	}

	function copyText(text, id) {
		if (!text) return;
		navigator.clipboard.writeText(text).then(() => {
			copiedId = id;
			if (timeoutId) clearTimeout(timeoutId);
			timeoutId = setTimeout(() => {
				copiedId = null;
				timeoutId = null;
			}, 2000);
		});
	}

	function clearAll() {
		output = [];
		copiedId = null;
	}

	$effect(() => {
		return () => {
			if (timeoutId) clearTimeout(timeoutId);
		};
	});
</script>

<div class="tool-container">
	<div class="tool-header">
		<h1>ID Generator</h1>
		<p class="tool-description">Generate UUID v4, UUID v7, ULID, Nano ID, Short UUID, and more with a single click.</p>
	</div>

	<div class="actions">
		<button class="btn btn-primary" onclick={generate}>
			<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
				<path d="M16 3h5v5" />
				<path d="M8 3H3v5" />
				<path d="M12 12v9" />
				<path d="m21 21-6-6" />
				<path d="m3 21 6-6" />
			</svg>
			Generate
		</button>
		<button class="btn btn-tertiary" onclick={clearAll} disabled={output.length === 0}>Reset</button>
	</div>

	{#if output.length > 0}
		<div class="output-section animate-fade-in">
			<div class="ids-grid">
				{#each output as item, index (index)}
					<div class="id-card">
						<div class="id-card-header">
							<span class="id-label">{item.label}</span>
							<button class="btn-copy" class:copied={copiedId === item.label} onclick={() => copyText(item.value, item.label)}>
								{#if copiedId === item.label}
									<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
										<polyline points="20 6 9 17 4 12" />
									</svg>
								{:else}
									<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
										<rect x="9" y="9" width="13" height="13" rx="2" ry="2" />
										<path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1" />
									</svg>
								{/if}
							</button>
						</div>
						<pre class="id-value">{item.value}</pre>
					</div>
				{/each}
			</div>
		</div>
	{/if}
</div>

<style>
	.tool-container {
		max-width: 1200px;
		margin: 0 auto;
		padding: 1rem;
		font-family: var(--font-family-sans);
	}

	.tool-header {
		margin-bottom: 2rem;
	}

	.tool-header h1 {
		font-size: 2rem;
		font-weight: 700;
		color: var(--text);
		margin-bottom: 0.5rem;
	}

	.tool-description {
		font-size: 1rem;
		color: var(--text-secondary);
	}

	.actions {
		display: flex;
		gap: 1rem;
		align-items: center;
		margin-bottom: 1.5rem;
	}

	.btn {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 0.5rem;
		padding: 0.75rem 1.5rem;
		font-size: 0.95rem;
		font-weight: 500;
		border-radius: var(--radius);
		border: 1px solid transparent;
		cursor: pointer;
		transition: background-color 0.15s, border-color 0.15s, color 0.15s, box-shadow 0.15s;
		user-select: none;
	}

	.btn-primary {
		background: var(--primary);
		color: #ffffff;
	}

	.btn-primary:hover {
		background: var(--primary-hover);
	}

	.btn-primary:focus {
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.3);
	}

	.btn-tertiary {
		background: transparent;
		color: var(--text-secondary);
	}

	.btn-tertiary:hover {
		background: var(--surface);
		color: var(--text);
	}

	.btn-tertiary:disabled {
		opacity: 0.5;
		cursor: not-allowed;
		background: transparent;
		color: var(--text-secondary);
	}

	.output-section {
		margin-top: 0;
	}

	.ids-grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
		gap: 1rem;
	}

	.id-card {
		background: var(--surface);
		border: 1px solid var(--border);
		border-radius: var(--radius);
		padding: 0.75rem 1rem;
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
		transition: box-shadow 0.2s;
	}

	.id-card:hover {
		box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
	}

	.id-card-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}

	.id-label {
		font-size: 0.75rem;
		font-weight: 600;
		color: var(--text-secondary);
		text-transform: uppercase;
		letter-spacing: 0.04em;
	}

	.id-value {
		margin: 0;
		font-family: var(--font-family-mono);
		font-size: 0.9rem;
		color: var(--text);
		word-break: break-all;
		white-space: pre-wrap;
		line-height: 1.5;
	}

	.btn-copy {
		display: inline-flex;
		align-items: center;
		gap: 0.3rem;
		padding: 0.25rem 0.5rem;
		font-size: 0.7rem;
		font-weight: 500;
		color: var(--text-secondary);
		background: transparent;
		border: 1px solid var(--border);
		border-radius: var(--radius);
		cursor: pointer;
		transition: all 0.15s ease-in-out;
		user-select: none;
	}

	.btn-copy:hover {
		color: var(--text);
		background: var(--border);
	}

	.btn-copy.copied {
		color: #15803d;
		background: rgba(34, 197, 94, 0.1);
		border-color: #22c55e;
	}

	:global([data-theme='dark']) .btn-copy.copied {
		color: #4ade80;
		background: rgba(34, 197, 94, 0.15);
		border-color: #4ade80;
	}

	.animate-fade-in {
		animation: fadeIn 0.25s cubic-bezier(0.16, 1, 0.3, 1);
	}

	@keyframes fadeIn {
		from {
			opacity: 0;
			transform: translateY(4px);
		}
		to {
			opacity: 1;
			transform: translateY(0);
		}
	}
</style>
