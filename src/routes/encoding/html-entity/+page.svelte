<script>
	import { ArrowDown, CircleAlert } from '@lucide/svelte';
	let leftText = $state('');
	let rightText = $state('');
	let error = $state('');

	const sampleText = `&lt;h1&gt;Hello, World!&lt;/h1&gt;
&lt;p&gt;This text has &amp;quot;quotes&amp;quot; &amp;amp; &amp;apos;apostrophes&apos;.&lt;/p&gt;
&amp;copy; 2024 My Company`;

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

	function decode() {
		error = '';
		if (!leftText.trim()) {
			error = 'Please enter HTML entities to decode.';
			return;
		}
		try {
			const textarea = document.createElement('textarea');
			textarea.innerHTML = leftText;
			rightText = textarea.value;
		} catch (e) {
			error = 'Failed to decode HTML entities: ' + e.message;
		}
	}
</script>

<div class="tool-container">
	<div class="tool-header">
		<h1>HTML Entity Decode</h1>
		<p class="tool-description">Convert HTML entities back to their plain text characters.</p>
	</div>

	<div class="edit-view animate-fade-in">
		<div class="textareas-container">
			<div class="textarea-wrapper">
				<label for="raw-input">Raw HTML</label>
				<textarea
					id="raw-input"
					bind:value={leftText}
					placeholder="Paste HTML with entities here..."
					spellcheck="false"
				></textarea>
			</div>
			<div class="textarea-wrapper">
				<label for="decoded-output">Decoded Text</label>
				<textarea
					id="decoded-output"
					bind:value={rightText}
					placeholder="Decoded output will appear here..."
					spellcheck="false"
					readonly
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
			<button class="btn btn-primary" onclick={decode}>
				<ArrowDown size={16} />
				Decode
			</button>
			<button class="btn btn-secondary" onclick={loadSample}>Load Sample</button>
			<button class="btn btn-tertiary" onclick={clearInputs} disabled={!leftText && !rightText}>Clear</button>
		</div>
	</div>
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

	.textareas-container {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 1.5rem;
		margin-bottom: 1.5rem;
	}

	@media (max-width: 768px) {
		.textareas-container {
			grid-template-columns: 1fr;
		}
	}

	.textarea-wrapper {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
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

	.textarea-wrapper textarea:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
	}

	@media (max-width: 768px) {
		.textarea-wrapper textarea {
			height: 200px;
		}
		.tool-header h1 {
			font-size: 1.5rem;
		}
	}

	.textarea-wrapper textarea[readonly] {
		background: var(--background);
		cursor: default;
	}

	.actions {
		display: flex;
		gap: 1rem;
		align-items: center;
		margin-top: 1.5rem;
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
