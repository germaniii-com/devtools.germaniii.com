<script>
	let { children } = $props();
</script>

<div class="code-actions">
	{@render children()}
</div>

<style>
	.code-actions {
		padding: 0.5em 0.5em;
		width: 100%;
		display: flex;
		flex-direction: row;
		justify-content: flex-start;
		align-items: center;
		gap: 1em;
	}
</style>
