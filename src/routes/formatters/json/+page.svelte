<script lang="ts">
	import { CircleAlert, Download } from '@lucide/svelte';
	let jsonInput = $state('');
	let error = $state('');

	function formatJson() {
		try {
			error = '';
			if (!jsonInput.trim()) return;
			const parsed = JSON.parse(jsonInput);
			jsonInput = JSON.stringify(parsed, null, 2);
		} catch (e: any) {
			error = e.message;
		}
	}

	function clearInput() {
		jsonInput = '';
		error = '';
	}
</script>

<div class="json-formatter-container">
	<div class="tool-header">
		<h1>JSON Formatter</h1>
		<p class="tool-description">Prettify and validate your JSON data instantly.</p>
	</div>

	<div class="edit-view animate-fade-in">
		<div class="textarea-wrapper">
			<label for="json-input">JSON Input</label>
			<textarea
				id="json-input"
				bind:value={jsonInput}
				placeholder="Paste your JSON here..."
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
			<button class="btn btn-primary" onclick={formatJson}>
				<Download size={16} />
				Format JSON
			</button>
			<button class="btn btn-tertiary" onclick={clearInput} disabled={!jsonInput}> Clear </button>
		</div>
	</div>
</div>

<style>
	.json-formatter-container {
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

	@media (max-width: 768px) {
		.textarea-wrapper textarea {
			height: 300px;
		}
		.tool-header h1 {
			font-size: 1.5rem;
		}
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
