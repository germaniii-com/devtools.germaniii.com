<script>
	import { ArrowRight, ArrowLeft, CircleAlert } from '@lucide/svelte';
	let leftText = $state('');
	let rightText = $state('');
	let error = $state('');

	const sampleText = `Hello, World!
This is a test string with special chars: ñ, ü, 你好`;

	function loadSample() {
		leftText = sampleText;
		rightText = '';
		error = '';
	}

	function clearInputs() {
		leftText = '';
		rightText = '';
		error = '';
	}

	function encode() {
		error = '';
		if (!leftText.trim()) {
			error = 'Please enter text to encode.';
			return;
		}
		try {
			rightText = btoa(unescape(encodeURIComponent(leftText)));
		} catch (e) {
			error = 'Failed to encode: ' + e.message;
		}
	}

	function decode() {
		error = '';
		if (!rightText.trim()) {
			error = 'Please enter Base64 to decode.';
			return;
		}
		try {
			leftText = decodeURIComponent(escape(atob(rightText)));
		} catch (e) {
			error = 'Failed to decode: ' + e.message;
		}
	}
</script>

<div class="converter-container">
	<div class="tool-header">
		<h1>Base64 Encode / Decode</h1>
		<p class="tool-description">Encode text to Base64 or decode Base64 back to text.</p>
	</div>

	<div class="converter-panes animate-fade-in">
		<div class="pane">
			<label for="text-input">Plain Text</label>
			<textarea
				id="text-input"
				bind:value={leftText}
				placeholder="Paste text here..."
				spellcheck="false"
			></textarea>
		</div>

		<div class="converter-actions">
			<button class="btn btn-primary btn-convert" onclick={encode}>
				<ArrowRight size={16} />
				Encode
			</button>
			<button class="btn btn-secondary btn-convert" onclick={decode}>
				<ArrowLeft size={16} />
				Decode
			</button>
		</div>

		<div class="pane">
			<label for="base64-input">Base64</label>
			<textarea
				id="base64-input"
				bind:value={rightText}
				placeholder="Paste Base64 here..."
				spellcheck="false"
			></textarea>
		</div>
	</div>

	{#if error}
		<div class="error-banner animate-fade-in">
			<CircleAlert size={16} />
			{error}
		</div>
	{/if}

	<div class="actions">
		<button class="btn btn-secondary" onclick={loadSample}>Load Sample</button>
		<button class="btn btn-tertiary" onclick={clearInputs} disabled={!leftText && !rightText}>Clear</button>
	</div>
</div>

<style>
	.converter-container {
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

	.converter-panes {
		display: grid;
		grid-template-columns: 1fr auto 1fr;
		gap: 1rem;
		align-items: start;
		margin-bottom: 1.5rem;
	}

	@media (max-width: 768px) {
		.converter-panes {
			grid-template-columns: 1fr;
		}
	}

	.pane {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
	}

	.pane label {
		font-size: 0.85rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-secondary);
	}

	.pane textarea {
		width: 100%;
		height: 450px;
		padding: 1rem;
		border: 1px solid var(--border);
		border-radius: var(--radius);
		background: var(--surface);
		color: var(--text);
		font-family: var(--font-family-mono);
		font-size: 0.875rem;
		line-height: 1.5;
		resize: vertical;
		outline: none;
		transition: border-color 0.2s, box-shadow 0.2s;
	}

	.pane textarea:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
	}

	@media (max-width: 768px) {
		.pane textarea {
			height: 200px;
		}
		.tool-header h1 {
			font-size: 1.5rem;
		}
	}

	.converter-actions {
		display: flex;
		flex-direction: column;
		gap: 0.75rem;
		justify-content: center;
		padding-top: 2rem;
	}

	@media (max-width: 768px) {
		.converter-actions {
			flex-direction: row;
			padding-top: 0;
			justify-content: center;
		}
	}

	.btn-convert {
		white-space: nowrap;
		min-width: 90px;
	}

	.btn {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		gap: 0.5rem;
		padding: 0.75rem 1.25rem;
		font-size: 0.9rem;
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

	.btn-secondary:focus {
		box-shadow: 0 0 0 3px rgba(0, 0, 0, 0.05);
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

	.error-banner {
		display: flex;
		align-items: center;
		gap: 0.75rem;
		padding: 1rem;
		margin-bottom: 1.5rem;
		background: rgba(239, 68, 68, 0.1);
		border: 1px solid rgba(239, 68, 68, 0.2);
		border-radius: var(--radius);
		color: #ef4444;
		font-size: 0.875rem;
	}

	[data-theme='dark'] .error-banner {
		background: rgba(239, 68, 68, 0.15);
		color: #f87171;
	}

	.actions {
		display: flex;
		gap: 1rem;
		align-items: center;
		margin-top: 0;
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
