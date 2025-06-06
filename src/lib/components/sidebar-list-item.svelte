<script>
	let { item } = $props();
</script>

<a href={`${item.value}`} rel="nofollow">
	<li>
		-> {item.name}
	</li>
</a>

<style>
	a {
		text-decoration: none;
	}
	li {
		cursor: pointer;
		margin: 1em 0;
		color: var(--orange);

		&:hover {
			color: var(--orange-dim);
		}
	}
</style>
