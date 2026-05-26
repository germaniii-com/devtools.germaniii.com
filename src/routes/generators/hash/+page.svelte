<script>
	let inputText = $state('');
	let algorithm = $state('SHA-256');
	let output = $state('');
	let copied = $state(false);

	const sampleText = 'The quick brown fox jumps over the lazy dog';

	function loadSample() {
		inputText = sampleText;
	}

	function clearAll() {
		inputText = '';
		output = '';
		copied = false;
	}

	async function generate() {
		if (!inputText.trim()) {
			output = 'Please enter text to hash.';
			return;
		}
		try {
			const encoder = new TextEncoder();
			const data = encoder.encode(inputText);
			const hashBuffer = await crypto.subtle.digest(algorithm, data);
			const hashArray = Array.from(new Uint8Array(hashBuffer));
			output = hashArray.map((b) => b.toString(16).padStart(2, '0')).join('');
			copied = false;
		} catch (e) {
			output = 'Failed to generate hash: ' + e.message;
		}
	}

	function copyOutput() {
		if (!output) return;
		navigator.clipboard.writeText(output).then(() => {
			copied = true;
			setTimeout(() => (copied = false), 2000);
		});
	}

	let algorithmName = $derived({
		'SHA-1': 'SHA-1 (160-bit)',
		'SHA-256': 'SHA-256 (256-bit)',
		'SHA-384': 'SHA-384 (384-bit)',
		'SHA-512': 'SHA-512 (512-bit)'
	}[algorithm]);
</script>

<div class="tool-container">
	<div class="tool-header">
		<h1>Hash Generator</h1>
		<p class="tool-description">Generate hash values using SHA-1, SHA-256, SHA-384, and SHA-512.</p>
	</div>

	<div class="controls animate-fade-in">
		<div class="controls-row">
			<div class="control-group flex-1">
				<label for="hash-input">Input Text</label>
				<input
					id="hash-input"
					type="text"
					bind:value={inputText}
					placeholder="Enter text to hash..."
				/>
			</div>
			<div class="control-group">
				<label for="algorithm-select">Algorithm</label>
				<select id="algorithm-select" bind:value={algorithm}>
					<option value="SHA-1">SHA-1</option>
					<option value="SHA-256">SHA-256</option>
					<option value="SHA-384">SHA-384</option>
					<option value="SHA-512">SHA-512</option>
				</select>
			</div>
		</div>
	</div>

	<div class="actions">
		<button class="btn btn-primary" onclick={generate}>
			<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
				<path d="M5 12h14" />
				<path d="m12 5 7 7-7 7" />
			</svg>
			Hash
		</button>
		<button class="btn btn-secondary" onclick={loadSample}>Load Sample</button>
		<button class="btn btn-tertiary" onclick={clearAll} disabled={!inputText && !output}>Clear</button>
	</div>

	{#if output}
		<div class="output-section animate-fade-in">
			<div class="output-header">
				<span class="output-label">{algorithmName} Hash</span>
				<button class="btn-copy" class:copied onclick={copyOutput}>
					{#if copied}
						<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
							<polyline points="20 6 9 17 4 12" />
						</svg>
						Copied!
					{:else}
						<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
							<rect x="9" y="9" width="13" height="13" rx="2" ry="2" />
							<path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1" />
						</svg>
						Copy
					{/if}
				</button>
			</div>
			<textarea readonly class="output-textarea mono" value={output}></textarea>
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

	.controls {
		background: var(--surface);
		border: 1px solid var(--border);
		border-radius: var(--radius);
		padding: 1.5rem;
		margin-bottom: 1.5rem;
	}

	.controls-row {
		display: flex;
		gap: 1.5rem;
		flex-wrap: wrap;
		align-items: flex-end;
	}

	.control-group {
		display: flex;
		flex-direction: column;
		gap: 0.4rem;
		min-width: 160px;
	}

	.control-group.flex-1 {
		flex: 1;
	}

	.control-group label {
		font-size: 0.8rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-secondary);
	}

	.control-group input[type='text'],
	.control-group select {
		padding: 0.6rem 0.75rem;
		border: 1px solid var(--border);
		border-radius: var(--radius);
		background: var(--background);
		color: var(--text);
		font-size: 0.9rem;
		font-family: var(--font-family-mono);
		outline: none;
		transition: border-color 0.2s, box-shadow 0.2s;
	}

	.control-group input[type='text']:focus,
	.control-group select:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
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

	.btn-secondary {
		background: var(--surface);
		color: var(--text);
		border-color: var(--border);
	}

	.btn-secondary:hover {
		background: var(--border);
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

	.output-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 0.75rem;
	}

	.output-label {
		font-size: 0.85rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-secondary);
	}

	.btn-copy {
		display: inline-flex;
		align-items: center;
		gap: 0.35rem;
		padding: 0.35rem 0.75rem;
		font-size: 0.75rem;
		font-weight: 500;
		color: var(--text-secondary);
		background: var(--background);
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

	.output-textarea {
		width: 100%;
		height: 120px;
		padding: 1rem;
		border: 1px solid var(--border);
		border-radius: var(--radius);
		background: var(--surface);
		color: var(--text);
		font-size: 0.875rem;
		line-height: 1.5;
		resize: vertical;
		outline: none;
		cursor: default;
	}

	.output-textarea.mono {
		font-family: var(--font-family-mono);
	}

	.output-textarea:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
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
