<script>
	let inputText = $state('');

	const sampleText = `The quick brown fox jumps over the lazy dog.
This is a second line of text, specifically designed to test the string analyzer's capabilities.
It has various punctuation! Does it handle multiple sentences? Yes, it should.

New paragraphs are also counted. 1234567890 symbols and numbers included.`;

	function loadSample() {
		inputText = sampleText;
	}

	function clearInput() {
		inputText = '';
	}

	// Svelte 5 derived state for metadata
	let stats = $derived.by(() => {
		const text = inputText || '';
		const trimmedText = text.trim();

		// Basic counts
		const characters = text.length;
		const charactersNoSpaces = text.replace(/\s/g, '').length;
		const words = trimmedText ? trimmedText.split(/\s+/).length : 0;
		const lines = text ? text.split(/\r?\n/).length : 0;
		const paragraphs = text ? text.split(/\n\s*\n/).filter((p) => p.trim()).length : 0;

		// Byte size (UTF-8)
		const bytes = new TextEncoder().encode(text).length;

		// Advanced counts
		const uniqueWords = new Set(text.toLowerCase().match(/\b\w+\b/g) || []).size;
		const sentences = (text.match(/[.!?]+(?=\s|$)/g) || []).length;

		// Estimated times
		// Average reading speed: 200 words per minute
		// Average speaking speed: 130 words per minute
		const readingTimeSeconds = Math.round((words / 200) * 60);
		const speakingTimeSeconds = Math.round((words / 130) * 60);

		const formatTime = (totalSeconds) => {
			if (totalSeconds < 60) return `${totalSeconds}s`;
			const minutes = Math.floor(totalSeconds / 60);
			const seconds = totalSeconds % 60;
			return `${minutes}m ${seconds}s`;
		};

		return [
			{ label: 'Characters', value: characters.toLocaleString(), color: 'blue' },
			{ label: 'Chars (no spaces)', value: charactersNoSpaces.toLocaleString(), color: 'cyan' },
			{ label: 'Words', value: words.toLocaleString(), color: 'green' },
			{ label: 'Unique Words', value: uniqueWords.toLocaleString(), color: 'emerald' },
			{ label: 'Lines', value: lines.toLocaleString(), color: 'purple' },
			{ label: 'Paragraphs', value: paragraphs.toLocaleString(), color: 'pink' },
			{ label: 'Sentences', value: sentences.toLocaleString(), color: 'orange' },
			{ label: 'Bytes', value: bytes.toLocaleString(), color: 'slate' },
			{ label: 'Reading Time', value: formatTime(readingTimeSeconds), color: 'indigo' },
			{ label: 'Speaking Time', value: formatTime(speakingTimeSeconds), color: 'violet' }
		];
	});
</script>

<div class="string-analyzer-container">
	<div class="tool-header">
		<h1>String Analyzer</h1>
		<p class="tool-description">
			Analyze your text in real-time to get detailed metadata and statistics.
		</p>
	</div>

	<div class="stats-grid animate-fade-in">
		{#each stats as stat (stat.label)}
			<div class="stat-card {stat.color}">
				<span class="stat-label">{stat.label}</span>
				<span class="stat-value">{stat.value}</span>
			</div>
		{/each}
	</div>

	<div class="edit-view animate-fade-in">
		<div class="textarea-wrapper">
			<label for="analyzer-input">Input Text</label>
			<textarea
				id="analyzer-input"
				bind:value={inputText}
				placeholder="Type or paste text here to analyze..."
			></textarea>
		</div>

		<div class="actions">
			<button class="btn btn-secondary" onclick={loadSample}>Load Sample</button>
			<button class="btn btn-tertiary" onclick={clearInput} disabled={!inputText}> Clear </button>
		</div>
	</div>
</div>

<style>
	.string-analyzer-container {
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

	/* Stats Grid */
	.stats-grid {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
		gap: 1rem;
		margin-bottom: 2rem;
	}

	.stat-card {
		background: var(--surface);
		border: 1px solid var(--border);
		border-radius: var(--radius);
		padding: 1rem;
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
		transition:
			transform 0.2s,
			box-shadow 0.2s;
	}

	.stat-card:hover {
		transform: translateY(-2px);
		box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
	}

	.stat-label {
		font-size: 0.75rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-secondary);
	}

	.stat-value {
		font-size: 1.25rem;
		font-weight: 700;
		color: var(--text);
		font-family: var(--font-family-mono);
	}

	/* Stat colors */
	.stat-card.blue {
		border-left: 4px solid #3b82f6;
	}
	.stat-card.cyan {
		border-left: 4px solid #06b6d4;
	}
	.stat-card.green {
		border-left: 4px solid #10b981;
	}
	.stat-card.emerald {
		border-left: 4px solid #10b981;
	}
	.stat-card.purple {
		border-left: 4px solid #8b5cf6;
	}
	.stat-card.pink {
		border-left: 4px solid #ec4899;
	}
	.stat-card.orange {
		border-left: 4px solid #f97316;
	}
	.stat-card.slate {
		border-left: 4px solid #64748b;
	}
	.stat-card.indigo {
		border-left: 4px solid #6366f1;
	}
	.stat-card.violet {
		border-left: 4px solid #8b5cf6;
	}

	/* Textarea Styles */
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
		height: 400px;
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
		transition: all 0.15s ease-in-out;
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
