<script>
	import { Check, Copy } from '@lucide/svelte';
	let inputText = $state('');
	let useCaveman = $state(true);
	let useDisemvowel = $state(true);
	let useTelegraphese = $state(true);
	let useNewspeak = $state(false);
	let useTxtspk = $state(false);
	let copiedId = $state(null);
	let timeoutId = null;

	const sampleText = `The terrible weather made for a wonderfully cozy evening. Are you free tonight? I will see you later.`;

	function loadSample() {
		inputText = sampleText;
	}

	function clearInput() {
		inputText = '';
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

	function caveman(text) {
		if (!text.trim()) return '';
		let result = text;

		const articles =
			/\b(a|an|the|is|are|was|were|am|be|been|being|has|have|had|do|does|did|will|would|shall|should|can|could|may|might|must|this|that|these|those)\b/gi;
		result = result.replace(articles, '');

		result = result.replace(/\b(I|my|mine)\b/gi, 'Me');

		result = result.replace(/[^\w\s]/g, '');

		result = result.replace(/\s+/g, ' ').trim();

		result = result.toUpperCase();

		return result;
	}

	function disemvowel(text) {
		if (!text.trim()) return '';
		return text
			.split(/(\b)/)
			.map((part) => {
				if (/^[a-zA-Z]/.test(part)) {
					if (part.length === 1) return part;
					const first = part[0];
					const rest = part.slice(1).replace(/[aeiouyAEIOUY]/g, '');
					return first + rest;
				}
				return part;
			})
			.join('');
	}

	function newspeak(text) {
		if (!text.trim()) return '';

		const ungood =
			/\b(bad|terrible|awful|horrible|evil|wicked|nasty|poor|inferior|negative|unpleasant|unfavorable|dreadful|atrocious|lousy|abysmal|crummy|rotten|shitty)\b/gi;
		const plusgood =
			/\b(great|very|really|quite|extremely|highly|strongly|large|big|huge|immense|massive|significant|substantial|considerable)\b/gi;
		const doubleplusgood =
			/\b(splendid|amazing|wonderful|fantastic|magnificent|marvelous|superb|excellent|outstanding|extraordinary|incredible|fabulous|terrific|glorious|superlative)\b/gi;

		let result = text;

		result = result.replace(doubleplusgood, 'doubleplusgood');
		result = result.replace(plusgood, 'plusgood');
		result = result.replace(ungood, 'ungood');

		const deleteWords =
			/\b(a|an|the|is|are|was|were|am|be|been|being|has|have|had|do|does|did|this|that|these|those|very|quite|really|extremely|highly|somewhat|rather|pretty|fairly|some|any|every|each|all|both|few|several|much|many|my|mine|your|yours|his|her|its|our|theirs|i|you|he|she|it|we|they|me|him|us|them|and|or|but|so|for|nor|yet|to|too|also|just|then|there|here|in|on|at|by|with|from|of|about|into|through|during|before|after|above|below|between|out|off|over|under|again|further|more|once|as|than|because|if|while|although|since|until|meanwhile|therefore|however|indeed|instead|anyway|whatever)\b/gi;
		result = result.replace(deleteWords, '');

		result = result.replace(/[^\w\s]/g, '');

		result = result.replace(/\s+/g, ' ').trim();

		return result;
	}

	function txtspk(text) {
		if (!text.trim()) return '';

		let result = text;

		const wordMap = [
			[/\bare\b/gi, 'r'],
			[/\byou\b/gi, 'u'],
			[/\bsee\b/gi, 'c'],
			[/\bwhy\b/gi, 'y'],
			[/\bbe\b/gi, 'b'],
			[/\bto\b/gi, '2'],
			[/\btoo\b/gi, '2'],
			[/\btwo\b/gi, '2'],
			[/\bfor\b/gi, '4'],
			[/\bfour\b/gi, '4'],
			[/\bfore\b/gi, '4'],
			[/\bate\b/gi, '8'],
			[/\beight\b/gi, '8'],
			[/\btonight\b/gi, '2nite'],
			[/\blater\b/gi, 'l8r'],
			[/\bbefore\b/gi, 'b4'],
			[/\bgreat\b/gi, 'gr8'],
			[/\btomorrow\b/gi, '2moro'],
			[/\binternet\b/gi, 'net'],
			[/\bplease\b/gi, 'plz'],
			[/\byour\b/gi, 'ur'],
			[/\byou're\b/gi, 'ur'],
			[/\bthat\b/gi, 'dat'],
			[/\bthe\b/gi, 'da'],
			[/\band\b/gi, 'n'],
			[/\bthanks\b/gi, 'thx'],
			[/\bokay\b/gi, 'k'],
			[/\bphone\b/gi, 'fone'],
			[/\blove\b/gi, 'luv'],
			[/\bhate\b/gi, 'h8'],
			[/\bwait\b/gi, 'w8']
		];

		const phrases = [
			[/\bbe right back\b/gi, 'BRB'],
			[/\btalk to you later\b/gi, 'TTYL'],
			[/\bby the way\b/gi, 'BTW'],
			[/\bin my humble opinion\b/gi, 'IMHO'],
			[/\breally\b/gi, 'rly'],
			[/\blaugh(?:ing)? out loud\b/gi, 'LOL'],
			[/\boh my god\b/gi, 'OMG'],
			[/\bface to face\b/gi, 'F2F'],
			[/\b(?:as soon as possible|asap)\b/gi, 'ASAP'],
			[/\b(?:for what it('s)? worth)\b/gi, 'FWIW'],
			[/\b(?:rolling on (?:the )?floor laughing)\b/gi, 'ROFL']
		];

		for (const [pattern, replacement] of phrases) {
			result = result.replace(pattern, replacement);
		}

		for (const [pattern, replacement] of wordMap) {
			result = result.replace(pattern, replacement);
		}

		return result;
	}

	function applyCombined(text) {
		let result = text;
		if (useTelegraphese) result = telegraphese(result);
		if (useNewspeak) result = newspeak(result);
		if (useDisemvowel) result = disemvowel(result);
		if (useCaveman) result = caveman(result);
		if (useTxtspk) result = txtspk(result);
		return result;
	}

	function telegraphese(text) {
		if (!text.trim()) return '';

		let result = text;

		const filler =
			/\b(a|an|the|is|are|was|were|am|be|been|being|has|have|had|do|does|did|will|would|shall|should|can|could|may|might|must|this|that|these|those|my|mine|your|yours|his|her|hers|its|our|ours|their|theirs|i|you|he|she|it|we|they|me|him|us|them|and|or|but|so|for|nor|yet|very|really|quite|some|any|every|each|all|both|few|several|much|many|to|too|also|just|then|there|here|in|on|at|by|with|from|of|about|into|through|during|before|after|above|below|between|out|off|over|under|again|further|more|once|as|than|because|if|while|although|since|until|afterwards|meanwhile|therefore|however|indeed|instead|anyway|whatever)\b/gi;
		result = result.replace(filler, '');

		result = result.replace(/\band\b/gi, ',');

		result = result.replace(/[^\w\s,]/g, '');

		result = result.replace(/\s+/g, ' ').trim();

		result = result.replace(/[,]+/g, ',');

		result = result.replace(/\s*,/g, ',');

		result = result.replace(/,\s*/g, ', ').trim();

		result = result.replace(/([.!?]+)/g, ' STOP ');

		result = result.replace(/\s+STOP\s+/g, ' STOP ').trim();

		result = result.toUpperCase();

		return result;
	}

	let strategies = $derived.by(() => {
		return [
			{
				id: 'caveman',
				name: 'Caveman',
				desc: 'Remove articles, swap pronouns, lose punctuation, all caps',
				value: caveman(inputText)
			},
			{
				id: 'disemvowel',
				name: 'Disemvoweling',
				desc: 'Remove vowels unless they are the first letter of the word',
				value: disemvowel(inputText)
			},
			{
				id: 'telegraphese',
				name: 'Telegraphese',
				desc: 'Strip filler words, compress, stop sentences with STOP',
				value: telegraphese(inputText)
			},
			{
				id: 'newspeak',
				name: 'Newspeak',
				desc: 'Orwellian approach — collapse antonyms and magnitude words',
				value: newspeak(inputText)
			},
			{
				id: 'txtspk',
				name: 'Txtspk',
				desc: 'Phonetic shorthand — numbers for syllables, letters for words',
				value: txtspk(inputText)
			}
		];
	});

	let combinedValue = $derived(applyCombined(inputText));
</script>

<div class="shorteners-container">
	<div class="tool-header">
		<h1>String Shorteners</h1>
		<p class="tool-description">
			Shorten your text using different strategies — Caveman, Disemvoweling, Telegraphese, Newspeak,
			Txtspk, or all combined.
		</p>
	</div>

	<div class="edit-view animate-fade-in">
		<div class="textarea-wrapper">
			<label for="input-text">Input Text</label>
			<textarea
				id="input-text"
				bind:value={inputText}
				placeholder="Type or paste text here to shorten..."
			></textarea>
		</div>

		<div class="actions">
			<button class="btn btn-secondary" onclick={loadSample}>Load Sample</button>
			<button class="btn btn-tertiary" onclick={clearInput} disabled={!inputText}> Clear </button>
		</div>
	</div>

	<div class="strategies-section animate-fade-in">
		<div class="strategy-card combined-card">
			<div class="strategy-card-header">
				<div class="strategy-info">
					<span class="strategy-title">Combined</span>
					<div class="strategy-desc">Select which shorteners to apply in sequence</div>
				</div>
				<button
					class="btn-copy"
					class:copied={copiedId === 'combined'}
					onclick={() => copyToClipboard(combinedValue, 'combined')}
				>
					{#if copiedId === 'combined'}
						<span class="copied-text">Copied!</span>
						<Check size={14} />
					{:else}
						<span>Copy</span>
						<Copy size={14} />
					{/if}
				</button>
			</div>
			<div class="combined-options">
				<label class="checkbox-label">
					<input type="checkbox" bind:checked={useCaveman} />
					Caveman
				</label>
				<label class="checkbox-label">
					<input type="checkbox" bind:checked={useDisemvowel} />
					Disemvoweling
				</label>
				<label class="checkbox-label">
					<input type="checkbox" bind:checked={useTelegraphese} />
					Telegraphese
				</label>
				<label class="checkbox-label">
					<input type="checkbox" bind:checked={useNewspeak} />
					Newspeak
				</label>
				<label class="checkbox-label">
					<input type="checkbox" bind:checked={useTxtspk} />
					Txtspk
				</label>
			</div>
			<textarea
				readonly
				class="strategy-textarea"
				value={combinedValue}
				placeholder="Select at least one strategy above..."
			></textarea>
		</div>
		{#each strategies as strategy (strategy.id)}
			<div class="strategy-card">
				<div class="strategy-card-header">
					<div class="strategy-info">
						<span class="strategy-title">{strategy.name}</span>
						<div class="strategy-desc">{strategy.desc}</div>
					</div>
					<button
						class="btn-copy"
						class:copied={copiedId === strategy.id}
						onclick={() => copyToClipboard(strategy.value, strategy.id)}
					>
						{#if copiedId === strategy.id}
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
					class="strategy-textarea"
					value={strategy.value}
					placeholder="Shortened text will appear here..."
				></textarea>
			</div>
		{/each}
	</div>
</div>

<style>
	.shorteners-container {
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

	@media (max-width: 768px) {
		.tool-header h1 {
			font-size: 1.5rem;
		}
		.textarea-wrapper textarea {
			height: 120px;
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
		height: 180px;
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

	.strategies-section {
		display: flex;
		flex-direction: column;
		gap: 1.5rem;
		margin-top: 2.5rem;
	}

	.strategy-card {
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

	.strategy-card:hover {
		transform: translateY(-2px);
		box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
	}

	.strategy-card-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}

	.strategy-info {
		display: flex;
		flex-direction: column;
	}

	.strategy-title {
		font-weight: 600;
		font-size: 0.95rem;
		color: var(--text);
		font-family: var(--font-family-mono);
	}

	.strategy-desc {
		font-size: 0.75rem;
		color: var(--text-secondary);
		margin-top: 0.1rem;
	}

	.strategy-textarea {
		width: 100%;
		height: 100px;
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

	.strategy-textarea:focus {
		border-color: var(--primary);
	}

	.combined-options {
		display: flex;
		gap: 1rem;
		flex-wrap: wrap;
	}

	.checkbox-label {
		display: inline-flex;
		align-items: center;
		gap: 0.4rem;
		font-size: 0.85rem;
		color: var(--text);
		cursor: pointer;
		user-select: none;
	}

	.checkbox-label input[type='checkbox'] {
		accent-color: var(--primary);
		width: 1rem;
		height: 1rem;
		cursor: pointer;
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
