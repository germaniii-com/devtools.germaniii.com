<script>
	let paragraphs = $state(3);
	let wordsPerParagraph = $state(50);
	let startWithLorem = $state(true);
	let output = $state('');
	let copied = $state(false);

	const loremStart = [
		'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
		'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
		'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
	];

	const words = [
		'lorem', 'ipsum', 'dolor', 'sit', 'amet', 'consectetur', 'adipiscing', 'elit',
		'sed', 'do', 'eiusmod', 'tempor', 'incididunt', 'ut', 'labore', 'et', 'dolore',
		'magna', 'aliqua', 'enim', 'ad', 'minim', 'veniam', 'quis', 'nostrud',
		'exercitation', 'ullamco', 'laboris', 'nisi', 'aliquip', 'ex', 'ea', 'commodo',
		'consequat', 'duis', 'aute', 'irure', 'dolor', 'in', 'reprehenderit', 'voluptate',
		'velit', 'esse', 'cillum', 'fugiat', 'nulla', 'pariatur', 'excepteur', 'sint',
		'occaecat', 'cupidatat', 'non', 'proident', 'sunt', 'culpa', 'qui', 'officia',
		'deserunt', 'mollit', 'anim', 'id', 'est', 'laborum', 'fugiat', 'rerum',
		'facilis', 'expedita', 'distinctio', 'nam', 'libero', 'tempore', 'cum',
		'soluta', 'nobis', 'est', 'eligendi', 'optio', 'cumque', 'nihil', 'impedit',
		'quo', 'minus', 'id', 'quod', 'maxime', 'placeat', 'facere', 'possimus',
		'omnis', 'voluptas', 'assumenda', 'est', 'omnis', 'dolor', 'repellendus',
		'temporibus', 'autem', 'quibusdam', 'et', 'aut', 'officiis', 'debitis', 'aut',
		'rerum', 'necessitatibus', 'saepe', 'eveniet', 'ut', 'et', 'voluptates',
		'repudiandae', 'sunt', 'et', 'molestiae', 'non', 'recusandae', 'itaque',
		'earum', 'rerum', 'hic', 'tenetur', 'a', 'sapiente', 'delectus', 'ut', 'aut',
		'reiciendis', 'voluptatibus', 'maiores', 'alias', 'consequatur', 'aut',
		'perferendis', 'doloribus', 'asperiores', 'repellat'
	];

	function generate() {
		const result = [];
		for (let p = 0; p < paragraphs; p++) {
			let sentence;

			if (startWithLorem && p < loremStart.length) {
				sentence = loremStart[p];
			} else {
				sentence = generateSentence();
			}

			const remainingWords = [];
			for (let i = sentence.split(' ').length; i < wordsPerParagraph; i++) {
				remainingWords.push(words[Math.floor(Math.random() * words.length)]);
			}

			const allWords = [...sentence.split(' '), ...remainingWords];
			const paragraphText = buildParagraph(allWords);
			result.push(paragraphText);
		}
		output = result.join('\n\n');
		copied = false;
	}

	function generateSentence() {
		const count = 5 + Math.floor(Math.random() * 8);
		const sentenceWords = [];
		for (let i = 0; i < count; i++) {
			sentenceWords.push(words[Math.floor(Math.random() * words.length)]);
		}
		sentenceWords[0] = sentenceWords[0].charAt(0).toUpperCase() + sentenceWords[0].slice(1);
		return sentenceWords.join(' ') + '.';
	}

	function buildParagraph(wordList) {
		let text = wordList[0].charAt(0).toUpperCase() + wordList[0].slice(1);
		let wordCount = 1;
		for (let i = 1; i < wordList.length; i++) {
			const word = wordList[i];
			text += ' ' + word;
			wordCount++;
			if (wordCount >= 12 + Math.floor(Math.random() * 8) && i < wordList.length - 1) {
				if (Math.random() > 0.3) {
					text = text.replace(/[a-zA-Z]$/, (m) => m + '.');
				}
				if (Math.random() > 0.7) {
					text += '\n';
				}
				if (text.match(/[.!?]$/)) {
					text += ' ' + wordList[i + 1].charAt(0).toUpperCase() + wordList[i + 1].slice(1);
					i++;
				}
				wordCount = 0;
			}
		}
		if (!text.match(/[.!?]$/)) text += '.';
		return text;
	}

	function copyOutput() {
		if (!output) return;
		navigator.clipboard.writeText(output).then(() => {
			copied = true;
			setTimeout(() => (copied = false), 2000);
		});
	}

	function clearAll() {
		output = '';
		copied = false;
	}
</script>

<div class="tool-container">
	<div class="tool-header">
		<h1>Lorem Ipsum Generator</h1>
		<p class="tool-description">Generate placeholder text for layouts, mockups, and designs.</p>
	</div>

	<div class="controls animate-fade-in">
		<div class="controls-row">
			<div class="control-group">
				<label for="paragraphs-input">Paragraphs</label>
				<input id="paragraphs-input" type="number" bind:value={paragraphs} min="1" max="100" />
			</div>
			<div class="control-group">
				<label for="words-input">Words per Paragraph</label>
				<input id="words-input" type="number" bind:value={wordsPerParagraph} min="10" max="500" />
			</div>
			<div class="control-group checkbox-inline">
				<label class="checkbox-label">
					<input type="checkbox" bind:checked={startWithLorem} />
					<span>Start with "Lorem ipsum..."</span>
				</label>
			</div>
		</div>
	</div>

	<div class="actions">
		<button class="btn btn-primary" onclick={generate}>
			<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
				<path d="M5 12h14" />
				<path d="m12 5 7 7-7 7" />
			</svg>
			Generate
		</button>
		<button class="btn btn-tertiary" onclick={clearAll} disabled={!output}>Clear</button>
	</div>

	{#if output}
		<div class="output-section animate-fade-in">
			<div class="output-header">
				<span class="output-label">Generated Text ({paragraphs} paragraph{paragraphs > 1 ? 's' : ''})</span>
				<button class="btn-copy" class:copied onclick={copyOutput}>
					{#if copied}
						<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
							<polyline points="20 6 9 17 4 12" />
						</svg>
						Copied!
					{:else}
						<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
							<rect x="9" y="9" width="13" height="13" rx="2" ry="2" />
							<path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1" />
						</svg>
						Copy
					{/if}
				</button>
			</div>
			<textarea readonly class="output-textarea" value={output}></textarea>
		</div>
	{/if}
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

	.controls {
		background: var(--surface);
		border: 1px solid var(--border);
		border-radius: var(--radius);
		padding: 1.5rem;
		margin-bottom: 1.5rem;
	}

	.controls-row {
		display: flex;
		gap: 1.5rem;
		flex-wrap: wrap;
		align-items: flex-end;
	}

	.control-group {
		display: flex;
		flex-direction: column;
		gap: 0.4rem;
		min-width: 120px;
	}

	.control-group label {
		font-size: 0.8rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-secondary);
	}

	.control-group input[type='number'] {
		padding: 0.6rem 0.75rem;
		border: 1px solid var(--border);
		border-radius: var(--radius);
		background: var(--background);
		color: var(--text);
		font-size: 0.9rem;
		font-family: var(--font-family-mono);
		outline: none;
		transition: border-color 0.2s, box-shadow 0.2s;
		width: 100px;
	}

	.control-group input[type='number']:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
	}

	.checkbox-inline {
		justify-content: flex-end;
		padding-bottom: 0.2rem;
	}

	.checkbox-label {
		display: inline-flex;
		align-items: center;
		gap: 0.5rem;
		font-size: 0.9rem;
		color: var(--text);
		cursor: pointer;
		user-select: none;
	}

	.checkbox-label input[type='checkbox'] {
		accent-color: var(--primary);
		width: 16px;
		height: 16px;
		cursor: pointer;
	}

	.actions {
		display: flex;
		gap: 1rem;
		align-items: center;
		margin-bottom: 1.5rem;
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

	.output-section {
		margin-top: 0;
	}

	.output-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 0.75rem;
	}

	.output-label {
		font-size: 0.85rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-secondary);
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

	.output-textarea {
		width: 100%;
		height: 400px;
		padding: 1rem;
		border: 1px solid var(--border);
		border-radius: var(--radius);
		background: var(--surface);
		color: var(--text);
		font-family: var(--font-family-sans);
		font-size: 0.9rem;
		line-height: 1.7;
		resize: vertical;
		outline: none;
		cursor: default;
	}

	.output-textarea:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
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
