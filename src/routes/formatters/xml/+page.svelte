<script lang="ts">
	import { CircleAlert, Download } from '@lucide/svelte';
	let xmlInput = $state('');
	let error = $state('');

	function formatXml() {
		try {
			error = '';
			if (!xmlInput.trim()) return;

			let formatted = '';
			let indentLevel = 0;
			const tab = '  ';

			let text = xmlInput.replace(/>/g, '>\n').replace(/</g, '\n<');

			const lines = text.split('\n');
			for (const line of lines) {
				const trimmed = line.trim();
				if (!trimmed) continue;

				if (trimmed.startsWith('</') || trimmed.startsWith('-->')) {
					indentLevel--;
				}

				formatted += tab.repeat(Math.max(0, indentLevel)) + trimmed + '\n';

				if (
					trimmed.startsWith('<') &&
					!trimmed.startsWith('</') &&
					!trimmed.endsWith('/>') &&
					!trimmed.startsWith('<?') &&
					!trimmed.startsWith('<!--') &&
					!trimmed.startsWith('<!')
				) {
					indentLevel++;
				}
			}

			xmlInput = formatted.trim();
		} catch (e: any) {
			error = e.message ?? 'Invalid XML';
		}
	}

	function clearInput() {
		xmlInput = '';
		error = '';
	}
</script>

<div class="xml-formatter-container">
	<div class="tool-header">
		<h1>XML Formatter</h1>
		<p class="tool-description">Format and prettify your XML data instantly.</p>
	</div>

	<div class="edit-view animate-fade-in">
		<div class="textarea-wrapper">
			<label for="xml-input">XML Input</label>
			<textarea
				id="xml-input"
				bind:value={xmlInput}
				placeholder="Paste your XML here..."
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
			<button class="btn btn-primary" onclick={formatXml}>
				<Download size={16} />
				Format XML
			</button>
			<button class="btn btn-tertiary" onclick={clearInput} disabled={!xmlInput}> Clear </button>
		</div>
	</div>
</div>

<style>
	.xml-formatter-container {
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
