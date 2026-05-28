<script>
	import { ArrowLeft, RefreshCw } from '@lucide/svelte';
	let textLeft = $state('');
	let textRight = $state('');
	let showDiff = $state(false);
	let diffRows = $state([]);

	const sampleLeft = `the quick brown fox jumped over the lazy dog`;
	const sampleRight = `The quick brown fox jumped over the lazy dog.`;

	function loadSample() {
		textLeft = sampleLeft;
		textRight = sampleRight;
	}

	function clearInputs() {
		textLeft = '';
		textRight = '';
	}

	function resetAll() {
		textLeft = '';
		textRight = '';
		showDiff = false;
		diffRows = [];
	}

	// Character-level LCS helper for inline difference highlighting
	function diffStrings(s1, s2) {
		const M = s1.length;
		const N = s2.length;
		if (M === 0) return [{ type: 'insert', text: s2 }];
		if (N === 0) return [{ type: 'delete', text: s1 }];

		const dp = Array.from({ length: M + 1 }, () => new Array(N + 1).fill(0));
		for (let i = 1; i <= M; i++) {
			for (let j = 1; j <= N; j++) {
				if (s1[i - 1] === s2[j - 1]) {
					dp[i][j] = dp[i - 1][j - 1] + 1;
				} else {
					dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
				}
			}
		}

		let i = M;
		let j = N;
		const result = [];
		while (i > 0 || j > 0) {
			if (i > 0 && j > 0 && s1[i - 1] === s2[j - 1]) {
				result.unshift({ type: 'equal', text: s1[i - 1] });
				i--;
				j--;
			} else if (j > 0 && (i === 0 || dp[i][j - 1] >= dp[i - 1][j])) {
				result.unshift({ type: 'insert', text: s2[j - 1] });
				j--;
			} else {
				result.unshift({ type: 'delete', text: s1[i - 1] });
				i--;
			}
		}

		// Coalesce continuous segments of same type
		const coalesced = [];
		for (const segment of result) {
			const last = coalesced[coalesced.length - 1];
			if (last && last.type === segment.type) {
				last.text += segment.text;
			} else {
				coalesced.push({ ...segment });
			}
		}
		return coalesced;
	}

	function handleCompare() {
		const linesLeft = textLeft.split(/\r?\n/);
		const linesRight = textRight.split(/\r?\n/);

		// Trim identical prefix and suffix to drastically optimize runtime performance
		let prefixCount = 0;
		while (
			prefixCount < linesLeft.length &&
			prefixCount < linesRight.length &&
			linesLeft[prefixCount] === linesRight[prefixCount]
		) {
			prefixCount++;
		}

		let suffixCount = 0;
		while (
			suffixCount < linesLeft.length - prefixCount &&
			suffixCount < linesRight.length - prefixCount &&
			linesLeft[linesLeft.length - 1 - suffixCount] ===
				linesRight[linesRight.length - 1 - suffixCount]
		) {
			suffixCount++;
		}

		// Prefix rows
		const prefixRows = [];
		for (let k = 0; k < prefixCount; k++) {
			prefixRows.push({
				type: 'equal',
				oldLine: linesLeft[k],
				newLine: linesRight[k],
				oldIndex: k + 1,
				newIndex: k + 1
			});
		}

		// Suffix rows
		const suffixRows = [];
		for (let k = 0; k < suffixCount; k++) {
			const oldIdx = linesLeft.length - suffixCount + k;
			const newIdx = linesRight.length - suffixCount + k;
			suffixRows.push({
				type: 'equal',
				oldLine: linesLeft[oldIdx],
				newLine: linesRight[newIdx],
				oldIndex: oldIdx + 1,
				newIndex: newIdx + 1
			});
		}

		// Mid section rows (actual edit region)
		const midLeft = linesLeft.slice(prefixCount, linesLeft.length - suffixCount);
		const midRight = linesRight.slice(prefixCount, linesRight.length - suffixCount);

		const M = midLeft.length;
		const N = midRight.length;

		let midAlignment = [];
		if (M > 0 || N > 0) {
			const dp = Array.from({ length: M + 1 }, () => new Array(N + 1).fill(0));
			for (let i = 1; i <= M; i++) {
				for (let j = 1; j <= N; j++) {
					if (midLeft[i - 1] === midRight[j - 1]) {
						dp[i][j] = dp[i - 1][j - 1] + 1;
					} else {
						dp[i][j] = Math.max(
							midLeft[i - 1] === midRight[j - 1] ? dp[i - 1][j - 1] + 1 : 0,
							Math.max(dp[i - 1][j], dp[i][j - 1])
						);
					}
				}
			}

			let i = M;
			let j = N;
			while (i > 0 || j > 0) {
				if (i > 0 && j > 0 && midLeft[i - 1] === midRight[j - 1]) {
					midAlignment.unshift({
						type: 'equal',
						oldLine: midLeft[i - 1],
						newLine: midRight[j - 1],
						oldIndex: prefixCount + i,
						newIndex: prefixCount + j
					});
					i--;
					j--;
				} else if (j > 0 && (i === 0 || dp[i][j - 1] >= dp[i - 1][j])) {
					midAlignment.unshift({
						type: 'insert',
						oldLine: null,
						newLine: midRight[j - 1],
						oldIndex: null,
						newIndex: prefixCount + j
					});
					j--;
				} else {
					midAlignment.unshift({
						type: 'delete',
						oldLine: midLeft[i - 1],
						newLine: null,
						oldIndex: prefixCount + i,
						newIndex: null
					});
					i--;
				}
			}
		}

		// Post-process alignment to pair delete + insert into modify
		const midProcessed = [];
		let k = 0;
		while (k < midAlignment.length) {
			const deletes = [];
			while (k < midAlignment.length && midAlignment[k].type === 'delete') {
				deletes.push(midAlignment[k]);
				k++;
			}

			const inserts = [];
			while (k < midAlignment.length && midAlignment[k].type === 'insert') {
				inserts.push(midAlignment[k]);
				k++;
			}

			if (deletes.length > 0 || inserts.length > 0) {
				const commonLength = Math.min(deletes.length, inserts.length);
				for (let m = 0; m < commonLength; m++) {
					const oldLine = deletes[m].oldLine;
					const newLine = inserts[m].newLine;
					const charDiff = diffStrings(oldLine, newLine);

					midProcessed.push({
						type: 'modify',
						oldLine,
						newLine,
						oldIndex: deletes[m].oldIndex,
						newIndex: inserts[m].newIndex,
						charDiff
					});
				}

				for (let m = commonLength; m < deletes.length; m++) {
					midProcessed.push(deletes[m]);
				}

				for (let m = commonLength; m < inserts.length; m++) {
					midProcessed.push(inserts[m]);
				}
			} else {
				midProcessed.push(midAlignment[k]);
				k++;
			}
		}

		diffRows = [...prefixRows, ...midProcessed, ...suffixRows];
		showDiff = true;
	}

	let stats = $derived({
		additions: diffRows.filter((r) => r.type === 'insert').length,
		deletions: diffRows.filter((r) => r.type === 'delete').length,
		modifications: diffRows.filter((r) => r.type === 'modify').length,
		equals: diffRows.filter((r) => r.type === 'equal').length,
		total: diffRows.length
	});
</script>

<div class="text-compare-container">
	<div class="tool-header">
		<h1>Text Compare</h1>
		<p class="tool-description">
			Compare two texts side-by-side with word-level difference highlighting.
		</p>
	</div>

	{#if !showDiff}
		<div class="edit-view animate-fade-in">
			<div class="textareas-container">
				<div class="textarea-wrapper">
					<label for="original-text">Original Text</label>
					<textarea
						id="original-text"
						bind:value={textLeft}
						placeholder="Paste or type original text here..."
					></textarea>
				</div>
				<div class="textarea-wrapper">
					<label for="modified-text">Modified Text</label>
					<textarea
						id="modified-text"
						bind:value={textRight}
						placeholder="Paste or type modified text here..."
					></textarea>
				</div>
			</div>

			<div class="actions">
				<button class="btn btn-primary" onclick={handleCompare}>
					<RefreshCw size={16} />
					Compare Texts
				</button>
				<button class="btn btn-secondary" onclick={loadSample}>Load Sample</button>
				<button class="btn btn-tertiary" onclick={clearInputs} disabled={!textLeft && !textRight}>
					Clear
				</button>
			</div>
		</div>
	{:else}
		<div class="diff-view animate-fade-in">
			<div class="diff-toolbar">
				<div class="stats">
					<span class="stat-badge total">Total rows: {stats.total}</span>
					{#if stats.additions > 0}
						<span class="stat-badge addition"
							>+{stats.additions} addition{stats.additions > 1 ? 's' : ''}</span
						>
					{/if}
					{#if stats.deletions > 0}
						<span class="stat-badge deletion"
							>-{stats.deletions} deletion{stats.deletions > 1 ? 's' : ''}</span
						>
					{/if}
					{#if stats.modifications > 0}
						<span class="stat-badge modification"
							>~{stats.modifications} modification{stats.modifications > 1 ? 's' : ''}</span
						>
					{/if}
					{#if stats.equals === stats.total && stats.total > 0}
						<span class="stat-badge match">Texts are identical! ✨</span>
					{/if}
				</div>
				<div class="toolbar-actions">
					<button class="btn btn-secondary" onclick={() => (showDiff = false)}>
						<ArrowLeft size={16} />
						Edit Inputs
					</button>
					<button class="btn btn-tertiary" onclick={resetAll}>Reset</button>
				</div>
			</div>

			<div class="diff-headers">
				<div class="diff-header-pane">Original Text</div>
				<div class="diff-header-pane">Modified Text</div>
			</div>

			<div class="diff-container">
				{#each diffRows as row, index (index)}
					<div class="diff-row {row.type}">
						<!-- Left Pane (Original) -->
						<div class="diff-pane left">
							<span class="line-number">{row.oldIndex ?? ''}</span>
							<span class="sign">{row.type === 'delete' || row.type === 'modify' ? '-' : ''}</span>
							<!-- prettier-ignore -->
							<pre class="content">{#if row.type === 'modify'}{#each row.charDiff as segment, sIdx (sIdx)}{#if segment.type !== 'insert'}<span class={segment.type === 'delete' ? 'diff-char-delete' : ''}>{segment.text}</span>{/if}{/each}{:else if row.type === 'delete'}{row.oldLine}{:else if row.type === 'equal'}{row.oldLine}{/if}</pre>
						</div>

						<!-- Right Pane (Modified) -->
						<div class="diff-pane right">
							<span class="line-number">{row.newIndex ?? ''}</span>
							<span class="sign">{row.type === 'insert' || row.type === 'modify' ? '+' : ''}</span>
							<!-- prettier-ignore -->
							<pre class="content">{#if row.type === 'modify'}{#each row.charDiff as segment, sIdx (sIdx)}{#if segment.type !== 'delete'}<span class={segment.type === 'insert' ? 'diff-char-insert' : ''}>{segment.text}</span>{/if}{/each}{:else if row.type === 'insert'}{row.newLine}{:else if row.type === 'equal'}{row.newLine}{/if}</pre>
						</div>
					</div>
				{/each}
			</div>
		</div>
	{/if}
</div>

<style>
	.text-compare-container {
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

	.textarea-wrapper textarea {
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

	.textarea-wrapper textarea:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
	}

	@media (max-width: 768px) {
		.textarea-wrapper textarea {
			height: 250px;
		}
		.tool-header h1 {
			font-size: 1.5rem;
		}
		.actions {
			flex-wrap: wrap;
		}
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

	/* Diff View Styles */
	.diff-toolbar {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 1rem;
		margin-bottom: 1.5rem;
		padding: 1rem;
		background: var(--surface);
		border: 1px solid var(--border);
		border-radius: var(--radius);
	}

	@media (max-width: 768px) {
		.diff-toolbar {
			flex-direction: column;
			align-items: flex-start;
		}
		.toolbar-actions {
			width: 100%;
			justify-content: flex-end;
		}
	}

	.stats {
		display: flex;
		flex-wrap: wrap;
		gap: 0.5rem;
		align-items: center;
	}

	.stat-badge {
		display: inline-flex;
		align-items: center;
		padding: 0.25rem 0.75rem;
		font-size: 0.8rem;
		font-weight: 600;
		border-radius: 9999px;
	}

	.stat-badge.total {
		background: var(--border);
		color: var(--text-secondary);
	}

	.stat-badge.addition {
		background: rgba(34, 197, 94, 0.12);
		color: #15803d;
	}

	[data-theme='dark'] .stat-badge.addition {
		color: #4ade80;
	}

	.stat-badge.deletion {
		background: rgba(239, 68, 68, 0.12);
		color: #b91c1c;
	}

	[data-theme='dark'] .stat-badge.deletion {
		color: #f87171;
	}

	.stat-badge.modification {
		background: rgba(234, 179, 8, 0.12);
		color: #a16207;
	}

	[data-theme='dark'] .stat-badge.modification {
		color: #fde047;
	}

	.stat-badge.match {
		background: rgba(168, 85, 247, 0.12);
		color: #7e22ce;
	}

	[data-theme='dark'] .stat-badge.match {
		color: #c084fc;
	}

	.toolbar-actions {
		display: flex;
		gap: 0.75rem;
	}

	.diff-headers {
		display: grid;
		grid-template-columns: 1fr 1fr;
		background: var(--surface);
		border: 1px solid var(--border);
		border-bottom: none;
		border-top-left-radius: var(--radius);
		border-top-right-radius: var(--radius);
	}

	.diff-header-pane {
		padding: 0.75rem 1rem;
		font-weight: 600;
		color: var(--text-secondary);
		font-size: 0.875rem;
		border-right: 1px solid var(--border);
	}

	.diff-header-pane:last-child {
		border-right: none;
	}

	.diff-container {
		display: flex;
		flex-direction: column;
		border: 1px solid var(--border);
		border-bottom-left-radius: var(--radius);
		border-bottom-right-radius: var(--radius);
		overflow: hidden;
		background: var(--background);
	}

	.diff-row {
		display: grid;
		grid-template-columns: 1fr 1fr;
		border-bottom: 1px solid var(--border);
	}

	.diff-row:last-child {
		border-bottom: none;
	}

	@media (max-width: 768px) {
		.diff-headers,
		.diff-row {
			grid-template-columns: 1fr;
		}
		.diff-row {
			gap: 1px;
		}
		.diff-header-pane:first-child {
			border-right: none;
			border-bottom: 1px solid var(--border);
		}
		.diff-pane {
			grid-template-columns: 2.5rem 1.5rem 1fr;
		}
		.diff-pane.left {
			border-right: none;
			border-bottom: 1px solid var(--border);
		}
	}

	.diff-pane {
		display: grid;
		grid-template-columns: 3.5rem 1.5rem 1fr;
		align-items: start;
		font-family: var(--font-family-mono);
		font-size: 0.85rem;
		line-height: 1.6;
		padding: 0.2rem 0;
		min-height: 1.6rem;
		white-space: pre-wrap;
	}

	.diff-pane.left {
		border-right: 1px solid var(--border);
	}

	.line-number {
		text-align: right;
		padding-right: 0.75rem;
		color: var(--text-secondary);
		opacity: 0.4;
		user-select: none;
		font-size: 0.75rem;
		margin-top: 0.1rem;
	}

	.sign {
		text-align: center;
		color: var(--text-secondary);
		opacity: 0.4;
		user-select: none;
		font-size: 0.85rem;
	}

	.content {
		margin: 0;
		padding: 0 0.5rem;
		font-family: var(--font-family-mono);
		font-size: 0.85rem;
		white-space: pre-wrap;
		word-break: break-all;
		min-height: 1.2rem;
		tab-size: 4;
		-moz-tab-size: 4;
	}

	/* Row and character colors */
	.diff-row.equal {
		/* standard */
	}

	/* Delete row */
	.diff-row.delete .diff-pane.left {
		background-color: rgba(239, 68, 68, 0.08);
	}
	.diff-row.delete .diff-pane.left .line-number,
	.diff-row.delete .diff-pane.left .sign {
		color: #ef4444;
		opacity: 0.8;
	}
	.diff-row.delete .diff-pane.right {
		background-color: rgba(128, 128, 128, 0.04);
	}

	/* Insert row */
	.diff-row.insert .diff-pane.left {
		background-color: rgba(128, 128, 128, 0.04);
	}
	.diff-row.insert .diff-pane.right {
		background-color: rgba(34, 197, 94, 0.08);
	}
	.diff-row.insert .diff-pane.right .line-number,
	.diff-row.insert .diff-pane.right .sign {
		color: #22c55e;
		opacity: 0.8;
	}

	/* Modify row */
	.diff-row.modify .diff-pane.left {
		background-color: rgba(239, 68, 68, 0.04);
	}
	.diff-row.modify .diff-pane.left .line-number,
	.diff-row.modify .diff-pane.left .sign {
		color: #ef4444;
		opacity: 0.8;
	}
	.diff-row.modify .diff-pane.right {
		background-color: rgba(34, 197, 94, 0.04);
	}
	.diff-row.modify .diff-pane.right .line-number,
	.diff-row.modify .diff-pane.right .sign {
		color: #22c55e;
		opacity: 0.8;
	}

	/* Character level differences */
	.diff-char-delete {
		background-color: rgba(239, 68, 68, 0.2);
		border-radius: 2px;
		color: #b91c1c;
	}
	[data-theme='dark'] .diff-char-delete {
		color: #fca5a5;
		background-color: rgba(239, 68, 68, 0.3);
	}

	.diff-char-insert {
		background-color: rgba(34, 197, 94, 0.2);
		border-radius: 2px;
		color: #15803d;
	}
	[data-theme='dark'] .diff-char-insert {
		color: #86efac;
		background-color: rgba(34, 197, 94, 0.3);
	}
</style>
