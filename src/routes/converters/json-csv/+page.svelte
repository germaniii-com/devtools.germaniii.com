<script>
	let leftText = $state('');
	let rightText = $state('');
	let error = $state('');

	const sampleJson = `[
  { "name": "Alice", "age": 30, "city": "New York" },
  { "name": "Bob", "age": 25, "city": "San Francisco" },
  { "name": "Charlie", "age": 35, "city": "Chicago" }
]`;

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

	function convertToCsv() {
		error = '';
		if (!leftText.trim()) {
			error = 'Please enter JSON on the left side.';
			return;
		}
		try {
			rightText = jsonToCsv(leftText);
		} catch (e) {
			error = e.message;
		}
	}

	function convertToJson() {
		error = '';
		if (!rightText.trim()) {
			error = 'Please enter CSV on the right side.';
			return;
		}
		try {
			leftText = csvToJson(rightText);
		} catch (e) {
			error = e.message;
		}
	}

	function jsonToCsv(jsonStr) {
		const arr = JSON.parse(jsonStr);
		if (!Array.isArray(arr)) throw new Error('JSON must be an array of objects.');
		if (arr.length === 0) throw new Error('JSON array must not be empty.');
		if (typeof arr[0] !== 'object' || arr[0] === null)
			throw new Error('JSON array must contain objects.');

		const keys = [...new Set(arr.flatMap((obj) => Object.keys(obj || {})))];
		const lines = [keys.map(escapeCsvField).join(',')];
		for (const obj of arr) {
			lines.push(
				keys
					.map((k) => escapeCsvField(obj[k] !== undefined && obj[k] !== null ? String(obj[k]) : ''))
					.join(',')
			);
		}
		return lines.join('\n');
	}

	function csvToJson(csvStr) {
		const lines = [];
		let current = '';
		let inQuotes = false;
		for (const ch of csvStr) {
			if (ch === '"') {
				inQuotes = !inQuotes;
				current += ch;
			} else if (ch === '\n' && !inQuotes) {
				lines.push(current);
				current = '';
			} else {
				current += ch;
			}
		}
		if (current.trim()) lines.push(current);

		if (lines.length < 2) throw new Error('CSV must have a header row and at least one data row.');

		const headers = parseCsvLine(lines[0]);
		if (headers.length === 0) throw new Error('CSV header row is empty.');

		const result = [];
		for (let i = 1; i < lines.length; i++) {
			if (!lines[i].trim()) continue;
			const values = parseCsvLine(lines[i]);
			const obj = {};
			headers.forEach((h, j) => {
				obj[h.trim()] = j < values.length ? values[j].trim() : '';
			});
			result.push(obj);
		}

		if (result.length === 0) throw new Error('CSV has no data rows.');

		return JSON.stringify(result, null, 2);
	}

	function parseCsvLine(line) {
		const fields = [];
		let current = '';
		let inQuotes = false;
		for (let i = 0; i < line.length; i++) {
			const ch = line[i];
			if (ch === '"') {
				if (inQuotes && i + 1 < line.length && line[i + 1] === '"') {
					current += '"';
					i++;
				} else {
					inQuotes = !inQuotes;
				}
			} else if (ch === ',' && !inQuotes) {
				fields.push(current);
				current = '';
			} else {
				current += ch;
			}
		}
		fields.push(current);
		return fields;
	}

	function escapeCsvField(val) {
		if (val.includes(',') || val.includes('"') || val.includes('\n') || val.includes('\r')) {
			return '"' + val.replace(/"/g, '""') + '"';
		}
		return val;
	}
</script>

<div class="converter-container">
	<div class="tool-header">
		<h1>JSON / CSV Converter</h1>
		<p class="tool-description">Convert between JSON and CSV formats bidirectionally.</p>
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
			<button class="btn btn-primary btn-convert" onclick={convertToCsv}>
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
				CSV
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
			<label for="csv-input">CSV</label>
			<textarea
				id="csv-input"
				bind:value={rightText}
				placeholder="Paste CSV here..."
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
