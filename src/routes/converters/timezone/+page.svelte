<script>
	import { ArrowRight, X, Plus } from '@lucide/svelte';
	let sourceDatetime = $state('');
	let sourceTimezone = $state('America/New_York');
	let targets = $state([
		{ id: 1, timezone: 'Europe/London' },
		{ id: 2, timezone: 'Asia/Tokyo' }
	]);
	let nextId = $state(3);

	const commonTimezones = [
		'Africa/Cairo',
		'Africa/Johannesburg',
		'America/Anchorage',
		'America/Chicago',
		'America/Denver',
		'America/Halifax',
		'America/Los_Angeles',
		'America/New_York',
		'America/Phoenix',
		'America/Sao_Paulo',
		'America/St_Johns',
		'Asia/Bangkok',
		'Asia/Dubai',
		'Asia/Hong_Kong',
		'Asia/Kolkata',
		'Asia/Seoul',
		'Asia/Shanghai',
		'America/Argentina/Buenos_Aires',
		'Asia/Singapore',
		'Asia/Tokyo',
		'Australia/Adelaide',
		'Australia/Brisbane',
		'Australia/Darwin',
		'Australia/Perth',
		'Australia/Sydney',
		'Europe/Berlin',
		'Europe/London',
		'Europe/Moscow',
		'Europe/Paris',
		'Pacific/Auckland',
		'Pacific/Honolulu',
		'UTC'
	].sort();

	const sampleDatetime = '2024-03-15T14:30';

	function loadSample() {
		sourceDatetime = sampleDatetime;
		sourceTimezone = 'America/New_York';
		targets = [
			{ id: 1, timezone: 'Europe/London' },
			{ id: 2, timezone: 'Asia/Tokyo' },
			{ id: 3, timezone: 'Australia/Sydney' }
		];
		nextId = 4;
	}

	function clearAll() {
		sourceDatetime = '';
		sourceTimezone = 'UTC';
		targets = [];
		nextId = 1;
	}

	function addTarget() {
		targets = [...targets, { id: nextId, timezone: 'UTC' }];
		nextId++;
	}

	function removeTarget(id) {
		targets = targets.filter((t) => t.id !== id);
	}

	function toUtcFromTimezone(datetimeStr, timezone) {
		if (!datetimeStr) return null;
		const [datePart, timePart] = datetimeStr.split('T');
		if (!datePart || !timePart) return null;
		const [y, m, d] = datePart.split('-').map(Number);
		const [h, min] = timePart.split(':').map(Number);
		if ([y, m, d, h, min].some(isNaN)) return null;

		const utcDate = new Date(Date.UTC(y, m - 1, d, h, min));

		const formatter = new Intl.DateTimeFormat('en-CA', {
			timeZone: timezone,
			year: 'numeric',
			month: '2-digit',
			day: '2-digit',
			hour: '2-digit',
			minute: '2-digit',
			hour12: false
		});
		const tzStr = formatter.format(utcDate);
		const [formattedDate, formattedTime] = tzStr.split(', ');
		if (!formattedDate || !formattedTime) return null;
		const [fy, fm, fd] = formattedDate.split('-').map(Number);
		const [fh, fmin] = formattedTime.split(':').map(Number);
		if ([fy, fm, fd, fh, fmin].some(isNaN)) return null;

		const tzClockUtc = Date.UTC(fy, fm - 1, fd, fh, fmin);
		const offsetMs = tzClockUtc - utcDate.getTime();
		return new Date(utcDate.getTime() - offsetMs);
	}

	function formatInTimezone(date, timezone) {
		if (!date) return '';
		return date.toLocaleString('en-US', {
			timeZone: timezone,
			weekday: 'short',
			year: 'numeric',
			month: 'short',
			day: 'numeric',
			hour: '2-digit',
			minute: '2-digit',
			hour12: true,
			timeZoneName: 'short'
		});
	}

	function getOffsetLabel(date, timezone) {
		if (!date) return '';
		const parts = new Intl.DateTimeFormat('en', {
			timeZone: timezone,
			timeZoneName: 'longOffset'
		}).formatToParts(date);
		const tzName = parts.find((p) => p.type === 'timeZoneName')?.value || '';
		return tzName.replace('GMT', 'UTC');
	}

	let sourceDate = $derived.by(() => toUtcFromTimezone(sourceDatetime, sourceTimezone));

	let sourceOffset = $derived.by(() => getOffsetLabel(sourceDate, sourceTimezone));

	let targetDisplays = $derived.by(() =>
		targets.map((t) => ({
			...t,
			display: formatInTimezone(sourceDate, t.timezone),
			offset: getOffsetLabel(sourceDate, t.timezone)
		}))
	);
</script>

<div class="timezone-converter-container">
	<div class="tool-header">
		<h1>Timezone Converter</h1>
		<p class="tool-description">
			Convert a date and time across multiple timezones simultaneously.
		</p>
	</div>

	<div class="converter-panes animate-fade-in">
		<div class="source-pane">
			<div class="pane-header">
				<h2>Source Time</h2>
				<span class="pane-timezone-label">{sourceTimezone} ({sourceOffset})</span>
			</div>
			<div class="source-inputs">
				<div class="field">
					<label for="source-datetime">Date & Time</label>
					<input type="datetime-local" id="source-datetime" bind:value={sourceDatetime} />
				</div>
				<div class="field">
					<label for="source-tz">Timezone</label>
					<select id="source-tz" bind:value={sourceTimezone}>
						{#each commonTimezones as tz (tz)}
							<option value={tz}>{tz}</option>
						{/each}
					</select>
				</div>
			</div>
			{#if sourceDate}
				<div class="source-display animate-fade-in">
					<span class="display-label">Converted</span>
					<span class="display-time">{formatInTimezone(sourceDate, sourceTimezone)}</span>
				</div>
			{/if}
		</div>

		<div class="divider-column">
			<div class="arrow-icon">
				<ArrowRight size={24} />
			</div>
		</div>

		<div class="targets-pane">
			<div class="pane-header">
				<h2>Target Times</h2>
			</div>
			<div class="targets-list">
				{#each targetDisplays as target (target.id)}
					<div class="target-row animate-fade-in">
						<div class="target-row-top">
							<select
								bind:value={target.timezone}
								onchange={(e) => {
									targets = targets.map((t) =>
										t.id === target.id ? { ...t, timezone: e.target.value } : t
									);
								}}
							>
								{#each commonTimezones as tz (tz)}
									<option value={tz}>{tz}</option>
								{/each}
							</select>
							<button
								class="btn-icon"
								onclick={() => removeTarget(target.id)}
								title="Remove timezone"
							>
								<X size={16} />
							</button>
						</div>
						<div class="target-display">
							{#if sourceDate}
								<span class="display-time">{target.display}</span>
								<span class="display-offset">{target.offset}</span>
							{:else}
								<span class="display-placeholder">No source time set</span>
							{/if}
						</div>
					</div>
				{/each}
			</div>

			{#if targets.length === 0}
				<div class="empty-state">No target timezones added.</div>
			{/if}

			<button class="btn btn-secondary btn-add" onclick={addTarget}>
				<Plus size={16} />
				Add Target
			</button>
		</div>
	</div>

	<div class="actions">
		<button class="btn btn-secondary" onclick={loadSample}>Load Sample</button>
		<button class="btn btn-tertiary" onclick={clearAll}>Clear</button>
	</div>
</div>

<style>
	.timezone-converter-container {
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
		gap: 1.5rem;
		align-items: start;
		margin-bottom: 1.5rem;
	}

	@media (max-width: 768px) {
		.converter-panes {
			grid-template-columns: 1fr;
		}
	}

	/* Source Pane */
	.source-pane {
		background: var(--surface);
		border: 1px solid var(--border);
		border-radius: var(--radius);
		padding: 1.25rem;
	}

	.pane-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 1rem;
	}

	.pane-header h2 {
		font-size: 1rem;
		font-weight: 600;
		color: var(--text);
	}

	.pane-timezone-label {
		font-size: 0.8rem;
		font-weight: 500;
		color: var(--text-secondary);
		font-family: var(--font-family-mono);
	}

	.source-inputs {
		display: flex;
		flex-direction: column;
		gap: 0.75rem;
	}

	.field {
		display: flex;
		flex-direction: column;
		gap: 0.35rem;
	}

	.field label {
		font-size: 0.75rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-secondary);
	}

	.field input,
	.field select {
		padding: 0.6rem 0.75rem;
		border: 1px solid var(--border);
		border-radius: var(--radius);
		background: var(--background);
		color: var(--text);
		font-size: 1rem;
		outline: none;
		transition:
			border-color 0.2s,
			box-shadow 0.2s;
	}

	.field input:focus,
	.field select:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
	}

	.source-display {
		margin-top: 1rem;
		padding: 0.75rem;
		background: var(--background);
		border: 1px solid var(--border);
		border-radius: var(--radius);
		display: flex;
		flex-direction: column;
		gap: 0.25rem;
	}

	.display-label {
		font-size: 0.7rem;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: var(--text-secondary);
	}

	.display-time {
		font-size: 1rem;
		font-weight: 600;
		color: var(--text);
		font-family: var(--font-family-mono);
	}

	.display-offset {
		font-size: 0.75rem;
		color: var(--text-secondary);
		font-family: var(--font-family-mono);
	}

	.display-placeholder {
		font-size: 0.85rem;
		color: var(--text-secondary);
		font-style: italic;
	}

	/* Divider */
	.divider-column {
		display: flex;
		align-items: center;
		justify-content: center;
		padding-top: 3rem;
	}

	.arrow-icon {
		color: var(--text-secondary);
		opacity: 0.5;
	}

	/* Targets Pane */
	.targets-pane {
		background: var(--surface);
		border: 1px solid var(--border);
		border-radius: var(--radius);
		padding: 1.25rem;
		display: flex;
		flex-direction: column;
		gap: 0.75rem;
	}

	.targets-list {
		display: flex;
		flex-direction: column;
		gap: 0.75rem;
	}

	.target-row {
		display: flex;
		flex-direction: column;
		gap: 0.5rem;
		padding: 0.75rem;
		background: var(--background);
		border: 1px solid var(--border);
		border-radius: var(--radius);
	}

	.target-row select {
		flex: 1;
		padding: 0.6rem 0.75rem;
		border: 1px solid var(--border);
		border-radius: var(--radius);
		background: var(--surface);
		color: var(--text);
		font-size: 1rem;
		outline: none;
		transition:
			border-color 0.2s,
			box-shadow 0.2s;
	}

	.target-row select:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
	}

	.target-row-top {
		display: flex;
		align-items: center;
		gap: 0.5rem;
	}

	.target-display {
		flex: 1;
		display: flex;
		flex-direction: column;
		gap: 0.15rem;
	}

	.target-display .display-time {
		font-size: 0.9rem;
	}

	/* Icon Button */
	.btn-icon {
		display: inline-flex;
		align-items: center;
		justify-content: center;
		width: 32px;
		height: 32px;
		padding: 0;
		border: 1px solid transparent;
		border-radius: var(--radius);
		background: transparent;
		color: var(--text-secondary);
		cursor: pointer;
		transition: all 0.15s;
		flex-shrink: 0;
	}

	.btn-icon:hover {
		background: rgba(239, 68, 68, 0.1);
		color: #ef4444;
	}

	/* Empty State */
	.empty-state {
		text-align: center;
		padding: 1.5rem;
		color: var(--text-secondary);
		font-size: 0.9rem;
		font-style: italic;
	}

	/* Buttons */
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
		transition: all 0.15s;
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

	.btn-add {
		width: 100%;
		justify-content: center;
		border-style: dashed;
	}

	.btn-add:hover {
		border-style: solid;
	}

	.actions {
		display: flex;
		gap: 1rem;
		align-items: center;
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
