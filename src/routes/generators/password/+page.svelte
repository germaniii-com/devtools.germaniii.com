<script>
	let length = $state(20);
	let includeUppercase = $state(true);
	let includeLowercase = $state(true);
	let includeNumbers = $state(true);
	let includeSymbols = $state(true);
	let excludeAmbiguous = $state(false);
	let output = $state('');
	let copied = $state(false);

	const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	const lowercase = 'abcdefghijklmnopqrstuvwxyz';
	const numbers = '0123456789';
	const symbols = '!@#$%^&*()_+-=[]{}|;:,.<>?~';
	const ambiguous = '0O1lI|';

	function generate() {
		let chars = '';
		if (includeUppercase) chars += uppercase;
		if (includeLowercase) chars += lowercase;
		if (includeNumbers) chars += numbers;
		if (includeSymbols) chars += symbols;
		if (excludeAmbiguous) {
			for (const ch of ambiguous) {
				chars = chars.replaceAll(ch, '');
			}
		}

		if (!chars) {
			output = 'Select at least one character type.';
			return;
		}

		const array = new Uint32Array(length);
		crypto.getRandomValues(array);
		output = Array.from(array, (v) => chars[v % chars.length]).join('');
		copied = false;
	}

	function copyOutput() {
		if (!output) return;
		navigator.clipboard.writeText(output).then(() => {
			copied = true;
			setTimeout(() => (copied = false), 2000);
		});
	}

	function clearAll() {
		output = '';
		copied = false;
	}

	function loadSample() {
		length = 20;
		includeUppercase = true;
		includeLowercase = true;
		includeNumbers = true;
		includeSymbols = true;
		excludeAmbiguous = false;
	}

	let strength = $derived.by(() => {
		if (!output) return { label: '', level: 0, color: '' };
		const hasUpper = /[A-Z]/.test(output);
		const hasLower = /[a-z]/.test(output);
		const hasNumber = /[0-9]/.test(output);
		const hasSymbol = /[^a-zA-Z0-9]/.test(output);
		const types = hasUpper + hasLower + hasNumber + hasSymbol;
		const entropy = Math.log2(
			(hasUpper ? 26 : 0) + (hasLower ? 26 : 0) + (hasNumber ? 10 : 0) + (hasSymbol ? 32 : 0)
		) * output.length;

		if (entropy >= 100) return { label: 'Very Strong', level: 4, color: '#22c55e' };
		if (entropy >= 60) return { label: 'Strong', level: 3, color: '#3b82f6' };
		if (entropy >= 36) return { label: 'Medium', level: 2, color: '#f59e0b' };
		return { label: 'Weak', level: 1, color: '#ef4444' };
	});
</script>

<div class="tool-container">
	<div class="tool-header">
		<h1>Strong Password Generator</h1>
		<p class="tool-description">Generate secure, random passwords with configurable options.</p>
	</div>

	<div class="controls animate-fade-in">
		<div class="controls-row">
			<div class="control-group">
				<label for="length-slider">Length: {length}</label>
				<input id="length-slider" type="range" bind:value={length} min="4" max="128" />
			</div>
		</div>
		<div class="checkbox-group">
			<label class="checkbox-label">
				<input type="checkbox" bind:checked={includeUppercase} />
				<span>A-Z (Uppercase)</span>
			</label>
			<label class="checkbox-label">
				<input type="checkbox" bind:checked={includeLowercase} />
				<span>a-z (Lowercase)</span>
			</label>
			<label class="checkbox-label">
				<input type="checkbox" bind:checked={includeNumbers} />
				<span>0-9 (Numbers)</span>
			</label>
			<label class="checkbox-label">
				<input type="checkbox" bind:checked={includeSymbols} />
				<span>!@#$ (Symbols)</span>
			</label>
			<label class="checkbox-label">
				<input type="checkbox" bind:checked={excludeAmbiguous} />
				<span>Exclude Ambiguous (0O1lI|)</span>
			</label>
		</div>
	</div>

	<div class="actions">
		<button class="btn btn-primary" onclick={generate}>
			<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
				<path d="M5 12h14" />
				<path d="m12 5 7 7-7 7" />
			</svg>
			Generate
		</button>
		<button class="btn btn-secondary" onclick={loadSample}>Reset Options</button>
		<button class="btn btn-tertiary" onclick={clearAll} disabled={!output}>Clear</button>
	</div>

	{#if output}
		<div class="output-section animate-fade-in">
			<div class="output-header">
				<span class="output-label">Generated Password</span>
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
			<div class="password-display">
				<pre class="password-text">{output}</pre>
			</div>
			<div class="strength-bar">
				<div
					class="strength-fill"
					style="width: {strength.level * 25}%; background: {strength.color}"
				></div>
			</div>
			<div class="strength-label" style="color: {strength.color}">
				{strength.label}
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

	.controls {
		background: var(--surface);
		border: 1px solid var(--border);
		border-radius: var(--radius);
		padding: 1.5rem;
		margin-bottom: 1.5rem;
	}

	.controls-row {
		margin-bottom: 1rem;
	}

	.control-group {
		display: flex;
		flex-direction: column;
		gap: 0.4rem;
	}

	.control-group label {
		font-size: 0.8rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-secondary);
	}

	.control-group input[type='range'] {
		width: 100%;
		max-width: 400px;
		accent-color: var(--primary);
		height: 6px;
		cursor: pointer;
	}

	.checkbox-group {
		display: flex;
		flex-wrap: wrap;
		gap: 1rem;
	}

	.checkbox-label {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		font-size: 0.9rem;
		color: var(--text);
		cursor: pointer;
		user-select: none;
		padding: 0.4rem 0.75rem;
		background: var(--background);
		border: 1px solid var(--border);
		border-radius: var(--radius);
		transition: border-color 0.15s, background 0.15s;
	}

	.checkbox-label:hover {
		border-color: var(--primary);
	}

	.checkbox-label input[type='checkbox'] {
		accent-color: var(--primary);
		width: 16px;
		height: 16px;
		cursor: pointer;
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

	.password-display {
		background: var(--surface);
		border: 1px solid var(--border);
		border-radius: var(--radius);
		padding: 1rem;
		margin-bottom: 0.75rem;
	}

	.password-text {
		margin: 0;
		font-family: var(--font-family-mono);
		font-size: 1.25rem;
		font-weight: 700;
		color: var(--text);
		word-break: break-all;
		white-space: pre-wrap;
		letter-spacing: 0.05em;
	}

	.strength-bar {
		height: 6px;
		background: var(--border);
		border-radius: 3px;
		overflow: hidden;
		margin-bottom: 0.4rem;
	}

	.strength-fill {
		height: 100%;
		border-radius: 3px;
		transition: width 0.3s ease, background 0.3s ease;
	}

	.strength-label {
		font-size: 0.85rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
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
