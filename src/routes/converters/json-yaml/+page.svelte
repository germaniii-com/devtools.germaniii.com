<script>
	import yaml from 'js-yaml';

	let leftText = $state('');
	let rightText = $state('');
	let error = $state('');

	const sampleJson = `{
  "name": "Alice",
  "age": 30,
  "city": "New York",
  "hobbies": ["reading", "hiking", "coding"],
  "address": {
    "street": "123 Main St",
    "zip": "10001"
  }
}`;

	function loadSample() {
		leftText = sampleJson;
		rightText = '';
		error = '';
	}

	function clearInputs() {
		leftText = '';
		rightText = '';
		error = '';
	}

	function convertToYaml() {
		error = '';
		if (!leftText.trim()) {
			error = 'Please enter JSON on the left side.';
			return;
		}
		try {
			const parsed = JSON.parse(leftText);
			rightText = yaml
				.dump(parsed, { indent: 2, lineWidth: -1, noRefs: true, sortKeys: false })
				.trimEnd();
		} catch (e) {
			error = e.message;
		}
	}

	function convertToJson() {
		error = '';
		if (!rightText.trim()) {
			error = 'Please enter YAML on the right side.';
			return;
		}
		try {
			const parsed = yaml.load(rightText);
			if (parsed === undefined || parsed === null) {
				throw new Error('YAML parsed to null or undefined.');
			}
			leftText = JSON.stringify(parsed, null, 2);
		} catch (e) {
			error = e.message;
		}
	}
</script>

<div class="converter-container">
	<div class="tool-header">
		<h1>JSON / YAML Converter</h1>
		<p class="tool-description">Convert between JSON and YAML formats bidirectionally.</p>
	</div>

	<div class="converter-panes animate-fade-in">
		<div class="pane">
			<label for="json-input">JSON</label>
			<textarea
				id="json-input"
				bind:value={leftText}
				placeholder="Paste JSON here..."
				spellcheck="false"
			></textarea>
		</div>

		<div class="converter-actions">
			<button class="btn btn-primary btn-convert" onclick={convertToYaml}>
				<svg
					xmlns="http://www.w3.org/2000/svg"
					width="16"
					height="16"
					viewBox="0 0 24 24"
					fill="none"
					stroke="currentColor"
					stroke-width="2.5"
					stroke-linecap="round"
					stroke-linejoin="round"
				>
					<path d="M5 12h14" />
					<path d="m12 5 7 7-7 7" />
				</svg>
				YAML
			</button>
			<button class="btn btn-secondary btn-convert" onclick={convertToJson}>
				<svg
					xmlns="http://www.w3.org/2000/svg"
					width="16"
					height="16"
					viewBox="0 0 24 24"
					fill="none"
					stroke="currentColor"
					stroke-width="2.5"
					stroke-linecap="round"
					stroke-linejoin="round"
				>
					<path d="M19 12H5" />
					<path d="m12 19-7-7 7-7" />
				</svg>
				JSON
			</button>
		</div>

		<div class="pane">
			<label for="yaml-input">YAML</label>
			<textarea
				id="yaml-input"
				bind:value={rightText}
				placeholder="Paste YAML here..."
				spellcheck="false"
			></textarea>
		</div>
	</div>

	{#if error}
		<div class="error-banner animate-fade-in">
			<svg
				xmlns="http://www.w3.org/2000/svg"
				width="16"
				height="16"
				viewBox="0 0 24 24"
				fill="none"
				stroke="currentColor"
				stroke-width="2"
				stroke-linecap="round"
				stroke-linejoin="round"
			>
				<circle cx="12" cy="12" r="10" />
				<line x1="12" y1="8" x2="12" y2="12" />
				<line x1="12" y1="16" x2="12.01" y2="16" />
			</svg>
			{error}
		</div>
	{/if}

	<div class="actions">
		<button class="btn btn-secondary" onclick={loadSample}>Load Sample</button>
		<button class="btn btn-tertiary" onclick={clearInputs} disabled={!leftText && !rightText}
			>Clear</button
		>
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

	/* Converter Panes */
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
		transition:
			border-color 0.2s,
			box-shadow 0.2s;
	}

	.pane textarea:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
	}

	/* Converter Actions (between panes) */
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

	/* Buttons */
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

	/* Error Banner */
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
