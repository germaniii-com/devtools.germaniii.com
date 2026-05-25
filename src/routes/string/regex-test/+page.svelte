<script lang="ts">
	let regexPattern: string = '';
	let testString: string = '';
	let resultHtml: string = '';

	// Function to escape HTML special characters
	function escapeHtml(unsafe: string): string {
		return unsafe
			.replace(/&/g, '&amp;')
			.replace(/</g, '&lt;')
			.replace(/>/g, '&gt;')
			.replace(/"/g, '&quot;')
			.replace(/'/g, '&#039;');
	}

	// Function to append regex syntax
	function appendToRegex(syntax: string) {
		regexPattern += syntax;
	}

	$: {
		try {
			if (regexPattern.trim() === '') {
				resultHtml = escapeHtml(testString);
			} else {
				const regex = new RegExp(regexPattern, 'g');
				let lastIndex = 0;
				let htmlParts: string[] = [];

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
				resultHtml = htmlParts.join('');
			}
		} catch (e: any) {
			resultHtml = `<span class="error">${escapeHtml(e.message)}</span>`;
		}
	}
</script>

<h1>Regex Test</h1>
<p>Input your regular expression and the string to test against it.</p>

<div class="regex-container">
	<div>
		<label for="regex-pattern">Regular Expression:</label>
		<input type="text" id="regex-pattern" bind:value={regexPattern} placeholder="e.g., \d+" />
	</div>

	<div>
		<label for="test-string">Test String:</label>
		<textarea
			id="test-string"
			bind:value={testString}
			placeholder="e.g., This string contains 123 numbers and some text."
		></textarea>
	</div>

	<div>
		<h3>Result:</h3>
		<div class="result-display">
			{@html resultHtml}
		</div>
	</div>

	<div class="cheat-sheet">
		<h2>Regex Cheat Sheet & Quick Add</h2>
		<div class="cheat-sheet-grid">
			<button class="cheat-sheet-item" on:click={() => appendToRegex('.')}>
				<strong>.</strong>
				<span>Any character (except newline)</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('\d')}>
				<strong>\d</strong>
				<span>Any digit (0-9)</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('\w')}>
				<strong>\w</strong>
				<span>Any word character (a-zA-Z0-9_)</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('\s')}>
				<strong>\s</strong>
				<span>Any whitespace character</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('\D')}>
				<strong>\D</strong>
				<span>Any non-digit character</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('\W')}>
				<strong>\W</strong>
				<span>Any non-word character</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('\S')}>
				<strong>\S</strong>
				<span>Any non-whitespace character</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('[abc]')}>
				<strong>[abc]</strong>
				<span>One of a, b, or c</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('[^abc]')}>
				<strong>[^abc]</strong>
				<span>Not one of a, b, or c</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('[a-z]')}>
				<strong>[a-z]</strong>
				<span>Character in range a-z</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('^')}>
				<strong>^</strong>
				<span>Start of string</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('$')}>
				<strong>$</strong>
				<span>End of string</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('*')}>
				<strong>*</strong>
				<span>0 or more of previous</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('+')}>
				<strong>+</strong>
				<span>1 or more of previous</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('?')}>
				<strong>?</strong>
				<span>0 or 1 of previous</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('{n}')}>
				<strong>&lbrace;n&rbrace;</strong>
				<span>Exactly n of previous</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('{n,}')}>
				<strong>&bsol;&lbrace;n,&bsol;&rcub;</strong>
				<span>n or more of previous</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('{n,m}')}>
				<strong>&lbrace;(n, m)&rbrace;</strong>
				<span>n to m of previous</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('|')}>
				<strong>|</strong>
				<span>OR operator</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('()')}>
				<strong>()</strong>
				<span>Capturing group</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('(?:)')}>
				<strong>(?:)</strong>
				<span>Non-capturing group</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('(?=)')}>
				<strong>(?=)</strong>
				<span>Positive lookahead</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('(?!)')}>
				<strong>(?!)</strong>
				<span>Negative lookahead</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('(?<=)')}>
				<strong>(?&lt;=)</strong>
				<span>Positive lookbehind</span>
			</button>
			<button class="cheat-sheet-item" on:click={() => appendToRegex('(?<!)')}>
				<strong>(?&lt;!)</strong>
				<span>Negative lookbehind</span>
			</button>
		</div>
	</div>
</div>

<style>
	.regex-container {
		display: flex;
		flex-direction: column;
		gap: 1rem;
		padding: 1rem;
		max-width: 800px;
		margin: 0 auto;
	}
	input[type='text'],
	textarea {
		width: 100%;
		padding: 0.5rem;
		border: 1px solid #ccc;
		border-radius: 4px;
		font-family: monospace;
	}
	textarea {
		min-height: 150px;
		resize: vertical;
	}
	.result-display {
		border: 1px solid #eee;
		padding: 1rem;
		background-color: #f9f9f9;
		min-height: 150px;
		white-space: pre-wrap;
		word-wrap: break-word;
	}
	.cheat-sheet {
		margin-top: 2rem;
		border-top: 1px solid #eee;
		padding-top: 1rem;
	}
	.cheat-sheet h2 {
		margin-bottom: 1rem;
	}
	.cheat-sheet-grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
		gap: 0.5rem;
	}
	.cheat-sheet-item {
		padding: 0.5rem;
		border: 1px solid #ddd;
		border-radius: 4px;
		background-color: #fff;
		cursor: pointer;
		font-family: monospace;
		font-size: 0.9em;
		display: flex;
		flex-direction: column;
		justify-content: space-between;
	}
	.cheat-sheet-item:hover {
		background-color: #eef;
	}
	.cheat-sheet-item strong {
		color: #333;
	}
	.cheat-sheet-item span {
		color: #666;
		font-size: 0.8em;
	}
</style>
