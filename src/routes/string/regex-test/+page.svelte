<script>
	let regexPattern = $state('');
	let testString = $state('');

	// Function to escape HTML special characters
	function escapeHtml(unsafe) {
		if (typeof unsafe !== 'string') return '';
		return unsafe
			.replace(/&/g, '&amp;')
			.replace(/</g, '&lt;')
			.replace(/>/g, '&gt;')
			.replace(/"/g, '&quot;')
			.replace(/'/g, '&#039;');
	}

	// Function to append regex syntax
	function appendToRegex(syntax) {
		regexPattern += syntax;
	}

	const sampleRegexPattern = '\\d+';
	const sampleTestString = 'This string contains 123 numbers and some text.';

	function loadSample() {
		regexPattern = sampleRegexPattern;
		testString = sampleTestString;
	}

	function clearInputs() {
		regexPattern = '';
		testString = '';
	}

	// Svelte 5 derived state for regex test results
	let resultHtml = $derived.by(() => {
		try {
			if (regexPattern.trim() === '') {
				return escapeHtml(testString);
			} else {
				const regex = new RegExp(regexPattern, 'g');
				let lastIndex = 0;
				let htmlParts = [];

				for (const match of testString.matchAll(regex)) {
					if (match.index !== undefined) {
						// Add the part before the match
						htmlParts.push(escapeHtml(testString.substring(lastIndex, match.index)));
						// Add the matched part, highlighted
						htmlParts.push(`<span class="highlight">${escapeHtml(match[0])}</span>`);
						lastIndex = match.index + match[0].length;
					}
				}
				// Add any remaining part after the last match
				htmlParts.push(escapeHtml(testString.substring(lastIndex)));
				return htmlParts.join('');
			}
		} catch (e) {
			return `<span class="error">${escapeHtml(e.message)}</span>`;
		}
	});
</script>

<div class="regex-tool-container">
	<div class="tool-header">
		<h1>Regex Test</h1>
		<p class="tool-description">Input your regular expression and the string to test against it.</p>
	</div>

	<div class="edit-view animate-fade-in">
		<div class="textareas-container">
			<div class="textarea-wrapper">
				<label for="regex-pattern">Regular Expression</label>
				<input type="text" id="regex-pattern" bind:value={regexPattern} placeholder="e.g., \d+" />
			</div>
			<div class="textarea-wrapper">
				<label for="test-string">Test String</label>
				<textarea
					id="test-string"
					bind:value={testString}
					placeholder="e.g., This string contains 123 numbers and some text."
				></textarea>
			</div>
		</div>

		<div class="actions">
			<button class="btn btn-secondary" onclick={loadSample}>Load Sample</button>
			<button
				class="btn btn-tertiary"
				onclick={clearInputs}
				disabled={!regexPattern && !testString}
			>
				Clear
			</button>
		</div>

		<div class="result-display-wrapper">
			<h3>Result:</h3>
			<div class="result-display">
				{@html resultHtml}
			</div>
		</div>

		<div class="cheat-sheet">
			<h2>Regex Cheat Sheet & Quick Add</h2>
			<div class="cheat-sheet-grid">
				<button class="cheat-sheet-item" onclick={() => appendToRegex('.')}>
					<strong>.</strong>
					<span>Any character (except newline)</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('\\d')}>
					<strong>\d</strong>
					<span>Any digit (0-9)</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('\\w')}>
					<strong>\w</strong>
					<span>Any word character (a-zA-Z0-9_)</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('\\s')}>
					<strong>\s</strong>
					<span>Any whitespace character</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('\\D')}>
					<strong>\D</strong>
					<span>Any non-digit character</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('\\W')}>
					<strong>\W</strong>
					<span>Any non-word character</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('\\S')}>
					<strong>\S</strong>
					<span>Any non-whitespace character</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('[abc]')}>
					<strong>[abc]</strong>
					<span>One of a, b, or c</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('[^abc]')}>
					<strong>[^abc]</strong>
					<span>Not one of a, b, or c</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('[a-z]')}>
					<strong>[a-z]</strong>
					<span>Character in range a-z</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('^')}>
					<strong>^</strong>
					<span>Start of string</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('$')}>
					<strong>$</strong>
					<span>End of string</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('*')}>
					<strong>*</strong>
					<span>0 or more of previous</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('+')}>
					<strong>+</strong>
					<span>1 or more of previous</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('?')}>
					<strong>?</strong>
					<span>0 or 1 of previous</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('{n}')}>
					<strong>&lbrace;n&rbrace;</strong>
					<span>Exactly n of previous</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('{n,}')}>
					<strong>&bsol;&lbrace;n,&bsol;&rcub;</strong>
					<span>n or more of previous</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('{n,m}')}>
					<strong>&lbrace;(n, m)&rbrace;</strong>
					<span>n to m of previous</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('|')}>
					<strong>|</strong>
					<span>OR operator</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('()')}>
					<strong>()</strong>
					<span>Capturing group</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('(?:)')}>
					<strong>(?:)</strong>
					<span>Non-capturing group</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('(?=)')}>
					<strong>(?=)</strong>
					<span>Positive lookahead</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('(?!)')}>
					<strong>(?!)</strong>
					<span>Negative lookahead</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('(?<=)')}>
					<strong>(?&lt;=)</strong>
					<span>Positive lookbehind</span>
				</button>
				<button class="cheat-sheet-item" onclick={() => appendToRegex('(?<!)')}>
					<strong>(?&lt;!)</strong>
					<span>Negative lookbehind</span>
				</button>
			</div>
		</div>
	</div>
</div>

<style>
	.regex-tool-container {
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

	@media (max-width: 768px) {
		.tool-header h1 {
			font-size: 1.5rem;
		}
		.cheat-sheet-grid {
			grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
		}
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

	.textarea-wrapper input[type='text'],
	.textarea-wrapper textarea {
		width: 100%;
		height: 150px;
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

	.textarea-wrapper input[type='text'] {
		height: 50px;
		min-height: 50px;
		max-height: 50px;
	}

	.textarea-wrapper textarea:focus,
	.textarea-wrapper input[type='text']:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
	}

	.actions {
		display: flex;
		gap: 1rem;
		align-items: center;
		margin-top: 1.5rem;
		margin-bottom: 2rem;
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

	.result-display-wrapper {
		margin-bottom: 2rem;
	}

	.result-display-wrapper h3 {
		font-size: 1rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-secondary);
		margin-bottom: 0.5rem;
	}

	.result-display {
		border: 1px solid var(--border);
		padding: 1rem;
		background-color: var(--surface);
		min-height: 150px;
		white-space: pre-wrap;
		word-wrap: break-word;
		border-radius: var(--radius);
		font-family: var(--font-family-mono);
		font-size: 0.875rem;
		line-height: 1.5;
		color: var(--text);
	}

	:global(.highlight) {
		background-color: rgba(61, 139, 253, 0.2);
		color: var(--primary);
		padding: 0 2px;
		border-radius: 2px;
	}

	:global(.error) {
		color: #ef4444;
		font-weight: 600;
	}

	.cheat-sheet {
		margin-top: 2rem;
		border-top: 1px solid var(--border);
		padding-top: 1rem;
	}

	.cheat-sheet h2 {
		font-size: 1rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-secondary);
		margin-bottom: 1rem;
	}

	.cheat-sheet-grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
		gap: 0.5rem;
	}

	.cheat-sheet-item {
		padding: 0.75rem;
		border: 1px solid var(--border);
		border-radius: var(--radius);
		background-color: var(--surface);
		cursor: pointer;
		font-family: var(--font-family-mono);
		font-size: 0.9em;
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		transition:
			background-color 0.15s,
			border-color 0.15s,
			box-shadow 0.15s;
	}

	.cheat-sheet-item:hover {
		background-color: var(--border);
		border-color: var(--primary);
	}

	.cheat-sheet-item strong {
		color: var(--text);
		font-size: 1em;
		margin-bottom: 0.25rem;
	}

	.cheat-sheet-item span {
		color: var(--text-secondary);
		font-size: 0.8em;
	}
</style>
