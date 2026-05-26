<script>
	let inputText = $state('');

	const sampleText = '2024-03-15T14:30:00.000Z';

	function loadSample() {
		inputText = sampleText;
	}

	function clearInput() {
		inputText = '';
	}

	function parseTimestamp(str) {
		const s = str.trim();
		if (!s) return null;

		const num = Number(s);
		if (!isNaN(num) && /^-?\d+\.?\d*$/.test(s)) {
			if (num > 1e11) return new Date(num);
			return new Date(num * 1000);
		}

		const d = new Date(s);
		if (!isNaN(d.getTime())) return d;

		return null;
	}

	let date = $derived.by(() => {
		if (!inputText.trim()) return null;
		return parseTimestamp(inputText);
	});

	let error = $derived.by(() => {
		if (!inputText.trim()) return '';
		if (!date)
			return 'Invalid timestamp. Try Unix seconds (1700000000), milliseconds, or an ISO 8601 string.';
		return '';
	});

	let stats = $derived.by(() => {
		if (!date) return [];
		const unixSec = Math.floor(date.getTime() / 1000);
		const unixMs = date.getTime();
		const iso = date.toISOString();
		const utc = date.toUTCString();
		const locale = date.toLocaleString();
		const relative = getRelativeTime(date);
		const components = getDateComponents(date);
		return [
			{ label: 'Unix Seconds', value: unixSec.toLocaleString(), css: 'slate' },
			{ label: 'Unix Milliseconds', value: unixMs.toLocaleString(), css: 'blue' },
			{ label: 'ISO 8601', value: iso, css: 'cyan' },
			{ label: 'UTC String', value: utc, css: 'green' },
			{ label: 'Locale String', value: locale, css: 'emerald' },
			{ label: 'Relative Time', value: relative, css: 'orange' },
			{ label: 'Year', value: String(components.year), css: 'purple' },
			{ label: 'Month', value: String(components.month), css: 'pink' },
			{ label: 'Day', value: String(components.day), css: 'indigo' },
			{ label: 'Hour', value: String(components.hour), css: 'violet' },
			{ label: 'Minute', value: String(components.minute).padStart(2, '0'), css: 'slate' },
			{ label: 'Second', value: String(components.second).padStart(2, '0'), css: 'blue' },
			{ label: 'Day of Week', value: components.dayOfWeek, css: 'cyan' }
		];
	});

	function getRelativeTime(d) {
		const now = Date.now();
		const diff = d.getTime() - now;
		const absDiff = Math.abs(diff);
		const seconds = Math.floor(absDiff / 1000);
		const minutes = Math.floor(seconds / 60);
		const hours = Math.floor(minutes / 60);
		const days = Math.floor(hours / 24);
		const months = Math.floor(days / 30);
		const years = Math.floor(days / 365);

		const prefix = diff < 0 ? 'ago' : 'from now';

		if (years > 0) return `${years} year${years > 1 ? 's' : ''} ${prefix}`;
		if (months > 0) return `${months} month${months > 1 ? 's' : ''} ${prefix}`;
		if (days > 0) return `${days} day${days > 1 ? 's' : ''} ${prefix}`;
		if (hours > 0) return `${hours} hour${hours > 1 ? 's' : ''} ${prefix}`;
		if (minutes > 0) return `${minutes} minute${minutes > 1 ? 's' : ''} ${prefix}`;
		if (seconds > 0) return `${seconds} second${seconds > 1 ? 's' : ''} ${prefix}`;
		return 'Just now';
	}

	function getDateComponents(d) {
		const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
		return {
			year: d.getFullYear(),
			month: d.getMonth() + 1,
			day: d.getDate(),
			hour: d.getHours(),
			minute: d.getMinutes(),
			second: d.getSeconds(),
			dayOfWeek: days[d.getDay()]
		};
	}
</script>

<div class="timestamp-converter-container">
	<div class="tool-header">
		<h1>Timestamp Converter</h1>
		<p class="tool-description">
			Convert timestamps between Unix seconds, milliseconds, ISO 8601, and human-readable formats.
		</p>
	</div>

	{#if date}
		<div class="stats-grid animate-fade-in">
			{#each stats as stat (stat.label)}
				<div class="stat-card {stat.css}">
					<span class="stat-label">{stat.label}</span>
					<span class="stat-value">{stat.value}</span>
				</div>
			{/each}
		</div>
	{/if}

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

	<div class="edit-view animate-fade-in">
		<div class="textarea-wrapper">
			<label for="timestamp-input">Timestamp Value</label>
			<textarea
				id="timestamp-input"
				bind:value={inputText}
				placeholder="Paste Unix seconds, milliseconds, or ISO 8601 string..."
			></textarea>
		</div>

		<div class="actions">
			<button class="btn btn-secondary" onclick={loadSample}>Load Sample</button>
			<button class="btn btn-tertiary" onclick={clearInput} disabled={!inputText}>Clear</button>
		</div>
	</div>
</div>

<style>
	.timestamp-converter-container {
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
		grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
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
		font-size: 1rem;
		font-weight: 700;
		color: var(--text);
		font-family: var(--font-family-mono);
		word-break: break-all;
	}

	.stat-card.slate {
		border-left: 4px solid #64748b;
	}
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
	.stat-card.orange {
		border-left: 4px solid #f97316;
	}
	.stat-card.purple {
		border-left: 4px solid #8b5cf6;
	}
	.stat-card.pink {
		border-left: 4px solid #ec4899;
	}
	.stat-card.indigo {
		border-left: 4px solid #6366f1;
	}
	.stat-card.violet {
		border-left: 4px solid #8b5cf6;
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

	/* Edit View */
	.textarea-wrapper {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
		margin-bottom: 1.5rem;
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
</style>
