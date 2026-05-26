<script>
	let leftText = $state('');
	let rightText = $state('');
	let error = $state('');

	const sampleToken = `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJhZG1pbiI6dHJ1ZSwicm9sZXMiOlsidXNlciIsImFkbWluIl19.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c`;

	function loadSample() {
		leftText = sampleToken;
		rightText = '';
		error = '';
	}

	function clearInputs() {
		leftText = '';
		rightText = '';
		error = '';
	}

	function decode() {
		error = '';
		if (!leftText.trim()) {
			error = 'Please enter a JWT token to decode.';
			return;
		}

		const parts = leftText.trim().split('.');
		if (parts.length !== 3) {
			error = 'Invalid JWT token: expected 3 parts separated by dots.';
			return;
		}

		try {
			const header = JSON.parse(decodeBase64Url(parts[0]));
			const payload = JSON.parse(decodeBase64Url(parts[1]));

			rightText = JSON.stringify({ header, payload }, null, 2);
		} catch (e) {
			error = 'Failed to decode JWT: ' + e.message;
		}
	}

	function decodeBase64Url(str) {
		let base64 = str.replace(/-/g, '+').replace(/_/g, '/');
		while (base64.length % 4 !== 0) {
			base64 += '=';
		}
		return decodeURIComponent(escape(atob(base64)));
	}
</script>

<div class="tool-container">
	<div class="tool-header">
		<h1>JWT Decode</h1>
		<p class="tool-description">Decode JWT (JSON Web Token) header and payload without verification.</p>
	</div>

	<div class="edit-view animate-fade-in">
		<div class="textareas-container">
			<div class="textarea-wrapper">
				<label for="token-input">JWT Token</label>
				<textarea
					id="token-input"
					bind:value={leftText}
					placeholder="Paste JWT token here..."
					spellcheck="false"
				></textarea>
			</div>
			<div class="textarea-wrapper">
				<label for="decoded-output">Decoded Payload</label>
				<textarea
					id="decoded-output"
					bind:value={rightText}
					placeholder="Decoded output will appear here..."
					spellcheck="false"
					readonly
				></textarea>
			</div>
		</div>

		{#if error}
			<div class="error-banner animate-fade-in">
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
					<circle cx="12" cy="12" r="10" />
					<line x1="12" y1="8" x2="12" y2="12" />
					<line x1="12" y1="16" x2="12.01" y2="16" />
				</svg>
				{error}
			</div>
		{/if}

		<div class="actions">
			<button class="btn btn-primary" onclick={decode}>
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
					<path d="M12 5v14" />
					<path d="m5 12 7 7 7-7" />
				</svg>
				Decode
			</button>
			<button class="btn btn-secondary" onclick={loadSample}>Load Sample</button>
			<button class="btn btn-tertiary" onclick={clearInputs} disabled={!leftText && !rightText}>Clear</button>
		</div>
	</div>
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
		transition: border-color 0.2s, box-shadow 0.2s;
	}

	.textarea-wrapper textarea:focus {
		border-color: var(--primary);
		box-shadow: 0 0 0 3px rgba(61, 139, 253, 0.15);
	}

	.textarea-wrapper textarea[readonly] {
		background: var(--background);
		cursor: default;
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
