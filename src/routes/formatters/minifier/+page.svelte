<script lang="ts">
	import { CircleAlert, Download } from '@lucide/svelte';
	let codeInput = $state('');
	let error = $state('');

	function minifyCode() {
		try {
			error = '';
			if (!codeInput.trim()) return;

			codeInput = codeInput
				.replace(/\/\*[\s\S]*?\*\/|\/\/.*/g, '')
				.replace(/\s+/g, ' ')
				.replace(/>\s+</g, '><')
				.trim();
		} catch (e: any) {
			error = e.message;
		}
	}

	function clearInput() {
		codeInput = '';
		error = '';
	}
</script>

<div class="minifier-container">
	<div class="tool-header">
		<h1>Code Minifier</h1>
		<p class="tool-description">
			Compress your HTML, CSS, and JavaScript code by removing comments and whitespace.
		</p>
	</div>

	<div class="edit-view animate-fade-in">
		<div class="textarea-wrapper">
			<label for="code-input">Code Input</label>
			<textarea
				id="code-input"
				bind:value={codeInput}
				placeholder="Paste your HTML, CSS, or JS code here..."
				spellcheck="false"
			></textarea>
		</div>

		{#if error}
			<div class="error-banner">
				<CircleAlert size={16} />
				{error}
			</div>
		{/if}

		<div class="actions">
			<button class="btn btn-primary" onclick={minifyCode}>
				<Download size={16} />
				Minify Code
			</button>
			<button class="btn btn-tertiary" onclick={clearInput} disabled={!codeInput}> Clear </button>
		</div>
	</div>
</div>

<style>
	.minifier-container {
		max-width: 1000px;
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

	.textarea-wrapper {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
		margin-bottom: 1.5rem;
	}

	.textarea-wrapper label {
		font-size: 0.85rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-secondary);
	}

	.textarea-wrapper textarea {
		width: 100%;
		height: 500px;
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
		transition:
			border-color 0.2s,
			box-shadow 0.2s;
	}

	.textarea-wrapper textarea:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
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
		transition:
			background-color 0.15s,
			border-color 0.15s,
			color 0.15s,
			box-shadow 0.15s;
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
