<script>
	import { Check, Copy } from '@lucide/svelte';
	let inputText = $state('');
	let copiedId = $state(null);
	let timeoutId = null;

	const sampleText = `the quick brown fox jumps over the lazy dog\nhello_world-test.case\nJSON_Response-parser`;

	function loadSample() {
		inputText = sampleText;
	}

	function clearInput() {
		inputText = '';
	}

	// Splits a line into words using transitions and delimiters
	function splitWords(str) {
		if (!str) return [];
		// Handle camelCase / PascalCase transitions first
		let temp = str.replace(/([a-z0-9])([A-Z])/g, '$1 $2').replace(/([A-Z]+)([A-Z][a-z])/g, '$1 $2');

		// Replace non-alphanumeric characters with spaces
		temp = temp.replace(/[^a-zA-Z0-9]+/g, ' ');

		// Split by whitespace and filter out empty strings
		return temp.trim().split(/\s+/).filter(Boolean);
	}

	function toggleCase(str) {
		return str
			.split('')
			.map((char) => {
				if (char === char.toUpperCase()) {
					return char.toLowerCase();
				} else {
					return char.toUpperCase();
				}
			})
			.join('');
	}

	function alternatingCase(str) {
		let count = 0;
		return str
			.split('')
			.map((char) => {
				if (/[a-zA-Z]/.test(char)) {
					const res = count % 2 === 0 ? char.toLowerCase() : char.toUpperCase();
					count++;
					return res;
				}
				return char;
			})
			.join('');
	}

	function copyToClipboard(text, id) {
		if (!text) return;
		navigator.clipboard
			.writeText(text)
			.then(() => {
				copiedId = id;
				if (timeoutId) clearTimeout(timeoutId);
				timeoutId = setTimeout(() => {
					copiedId = null;
					timeoutId = null;
				}, 2000);
			})
			.catch((err) => {
				console.error('Failed to copy text: ', err);
			});
	}

	// Svelte 5 derived state for automatic conversion
	let cases = $derived.by(() => {
		const lines = inputText.split(/\r?\n/);

		const convertLine = (line, convertFn) => {
			if (line.trim() === '') return '';
			const words = splitWords(line);
			if (words.length === 0) return line;
			return convertFn(words);
		};

		const convertLineDirect = (line, convertFn) => {
			return convertFn(line);
		};

		const camelCaseStr = lines
			.map((l) =>
				convertLine(l, (words) =>
					words
						.map((w, i) =>
							i === 0 ? w.toLowerCase() : w.charAt(0).toUpperCase() + w.slice(1).toLowerCase()
						)
						.join('')
				)
			)
			.join('\n');

		const pascalCaseStr = lines
			.map((l) =>
				convertLine(l, (words) =>
					words.map((w) => w.charAt(0).toUpperCase() + w.slice(1).toLowerCase()).join('')
				)
			)
			.join('\n');

		const snakeCaseStr = lines
			.map((l) => convertLine(l, (words) => words.map((w) => w.toLowerCase()).join('_')))
			.join('\n');

		const kebabCaseStr = lines
			.map((l) => convertLine(l, (words) => words.map((w) => w.toLowerCase()).join('-')))
			.join('\n');

		const constantCaseStr = lines
			.map((l) => convertLine(l, (words) => words.map((w) => w.toUpperCase()).join('_')))
			.join('\n');

		const sentenceCaseStr = lines
			.map((l) =>
				convertLine(l, (words) =>
					words
						.map((w, i) =>
							i === 0 ? w.charAt(0).toUpperCase() + w.slice(1).toLowerCase() : w.toLowerCase()
						)
						.join(' ')
				)
			)
			.join('\n');

		const titleCaseStr = lines
			.map((l) =>
				convertLine(l, (words) =>
					words.map((w) => w.charAt(0).toUpperCase() + w.slice(1).toLowerCase()).join(' ')
				)
			)
			.join('\n');

		const lowerCaseStr = lines
			.map((l) => convertLine(l, (words) => words.map((w) => w.toLowerCase()).join(' ')))
			.join('\n');

		const upperCaseStr = lines
			.map((l) => convertLine(l, (words) => words.map((w) => w.toUpperCase()).join(' ')))
			.join('\n');

		const dotCaseStr = lines
			.map((l) => convertLine(l, (words) => words.map((w) => w.toLowerCase()).join('.')))
			.join('\n');

		const pathCaseStr = lines
			.map((l) => convertLine(l, (words) => words.map((w) => w.toLowerCase()).join('/')))
			.join('\n');

		const toggleCaseStr = lines.map((l) => convertLineDirect(l, toggleCase)).join('\n');

		const alternatingCaseStr = lines.map((l) => convertLineDirect(l, alternatingCase)).join('\n');

		return [
			{ id: 'camel', name: 'camelCase', value: camelCaseStr, desc: 'Camel Case' },
			{ id: 'pascal', name: 'PascalCase', value: pascalCaseStr, desc: 'Pascal Case' },
			{ id: 'snake', name: 'snake_case', value: snakeCaseStr, desc: 'Snake Case' },
			{ id: 'kebab', name: 'kebab-case', value: kebabCaseStr, desc: 'Kebab Case' },
			{
				id: 'constant',
				name: 'CONSTANT_CASE',
				value: constantCaseStr,
				desc: 'Constant Case / Upper Snake'
			},
			{ id: 'sentence', name: 'Sentence Case', value: sentenceCaseStr, desc: 'Sentence Case' },
			{ id: 'title', name: 'Title Case', value: titleCaseStr, desc: 'Title Case' },
			{ id: 'lower', name: 'lower case', value: lowerCaseStr, desc: 'Lower Case' },
			{ id: 'upper', name: 'UPPER CASE', value: upperCaseStr, desc: 'Upper Case' },
			{ id: 'dot', name: 'dot.case', value: dotCaseStr, desc: 'Dot Case' },
			{ id: 'path', name: 'path/case', value: pathCaseStr, desc: 'Path Case' },
			{ id: 'toggle', name: 'tOGGLE cASE', value: toggleCaseStr, desc: 'Toggle Case' },
			{
				id: 'alternating',
				name: 'aLtErNaTiNg CaSe',
				value: alternatingCaseStr,
				desc: 'Alternating Case'
			}
		];
	});
</script>

<div class="case-convert-container">
	<div class="tool-header">
		<h1>Case Convert</h1>
		<p class="tool-description">
			Live convert your multi-line text into different casing standards instantly.
		</p>
	</div>

	<div class="edit-view animate-fade-in">
		<div class="textarea-wrapper">
			<label for="input-text">Input Text</label>
			<textarea
				id="input-text"
				bind:value={inputText}
				placeholder="Type or paste text here to convert..."
			></textarea>
		</div>

		<div class="actions">
			<button class="btn btn-secondary" onclick={loadSample}>Load Sample</button>
			<button class="btn btn-tertiary" onclick={clearInput} disabled={!inputText}> Clear </button>
		</div>
	</div>

	<div class="cases-grid animate-fade-in">
		{#each cases as caseItem (caseItem.id)}
			<div class="case-card">
				<div class="case-card-header">
					<div class="case-info">
						<span class="case-title">{caseItem.name}</span>
						<div class="case-desc">{caseItem.desc}</div>
					</div>
					<button
						class="btn-copy"
						class:copied={copiedId === caseItem.id}
						onclick={() => copyToClipboard(caseItem.value, caseItem.id)}
					>
						{#if copiedId === caseItem.id}
							<span class="copied-text">Copied!</span>
							<Check size={14} />
						{:else}
							<span>Copy</span>
							<Copy size={14} />
						{/if}
					</button>
				</div>
				<textarea
					readonly
					class="case-textarea"
					value={caseItem.value}
					placeholder="Converted text will appear here..."
				></textarea>
			</div>
		{/each}
	</div>
</div>

<style>
	.case-convert-container {
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
		height: 200px;
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
		transition:
			background-color 0.15s,
			border-color 0.15s,
			color 0.15s,
			box-shadow 0.15s;
		user-select: none;
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

	/* Cases Grid */
	.cases-grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
		gap: 1.5rem;
		margin-top: 2.5rem;
	}

	.case-card {
		background: var(--surface);
		border: 1px solid var(--border);
		border-radius: var(--radius);
		padding: 1rem;
		display: flex;
		flex-direction: column;
		gap: 0.75rem;
		box-shadow: 0 1px 3px rgba(0, 0, 0, 0.02);
		transition:
			transform 0.2s,
			box-shadow 0.2s;
	}

	.case-card:hover {
		transform: translateY(-2px);
		box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
	}

	.case-card-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}

	.case-info {
		display: flex;
		flex-direction: column;
	}

	.case-title {
		font-weight: 600;
		font-size: 0.95rem;
		color: var(--text);
		font-family: var(--font-family-mono);
	}

	.case-desc {
		font-size: 0.75rem;
		color: var(--text-secondary);
		margin-top: 0.1rem;
	}

	.case-textarea {
		width: 100%;
		height: 120px;
		padding: 0.75rem;
		border: 1px solid var(--border);
		border-radius: var(--radius);
		background: var(--background);
		color: var(--text);
		font-family: var(--font-family-mono);
		font-size: 0.85rem;
		line-height: 1.4;
		resize: vertical;
		outline: none;
		transition: border-color 0.2s;
	}

	.case-textarea:focus {
		border-color: var(--primary);
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
		border-color: var(--text-secondary);
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
</style>
