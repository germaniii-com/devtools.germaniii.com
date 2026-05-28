<footer class="footer">
	<a class="personal-link" href="https://germaniii.com">German III Felisarta</a>
</footer>

<style>
	.footer {
		height: 100%;
		display: flex;
		align-items: center;
		justify-content: flex-end;
		gap: 1;
		padding: 0.75rem 2rem;
		background: var(--surface);
		border-top: 1px solid var(--border);
		box-shadow: var(--shadow);
	}

	.personal-link {
		color: var(--text-secondary);
		text-decoration: none;
		font-size: 0.85rem;
		font-weight: normal;
		font-family: var(--font-family-sans);
	}

	@media (max-width: 768px) {
		.footer {
			padding: 0.75rem 1rem;
			justify-content: center;
		}

		.personal-link {
			font-size: 0.75rem;
		}
	}
</style>
