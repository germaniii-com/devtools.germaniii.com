<script>
	let { children } = $props();
</script>

<p>{@render children()}</p>

<style>
	p {
		font-family: 'Noto Sans';
		color: var(--fg);
	}
</style>
