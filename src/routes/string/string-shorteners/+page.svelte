<script>
	import { Check, Copy } from '@lucide/svelte';
	let inputText = $state('');
	let copiedId = $state(null);
	let timeoutId = null;

	const sampleText = `Please remember to pick up the groceries. I am arriving in New York on Tuesday evening and I need my charger.`;

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

		const articles = /\b(a|an|the|is|are|was|were|am|be|been|being|has|have|had|do|does|did|will|would|shall|should|can|could|may|might|must|this|that|these|those)\b/gi;
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

	function combined(text) {
		return caveman(disemvowel(telegraphese(text)));
	}

	function telegraphese(text) {
		if (!text.trim()) return '';

		let result = text;

		const filler = /\b(a|an|the|is|are|was|were|am|be|been|being|has|have|had|do|does|did|will|would|shall|should|can|could|may|might|must|this|that|these|those|my|mine|your|yours|his|her|hers|its|our|ours|their|theirs|i|you|he|she|it|we|they|me|him|us|them|and|or|but|so|for|nor|yet|very|really|quite|some|any|every|each|all|both|few|several|much|many|to|too|also|just|then|there|here|in|on|at|by|with|from|of|about|into|through|during|before|after|above|below|between|out|off|over|under|again|further|more|once|as|than|because|if|while|although|since|until|afterwards|meanwhile|therefore|however|indeed|instead|anyway|whatever)\b/gi;
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
				id: 'combined',
				name: 'Combined',
				desc: 'All three shorteners applied together — maximum compression',
				value: combined(inputText)
			}
		];
	});
</script>

<div class="shorteners-container">
	<div class="tool-header">
		<h1>String Shorteners</h1>
		<p class="tool-description">
			Shorten your text using different strategies — Caveman, Disemvoweling, Telegraphese, or all combined.
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
