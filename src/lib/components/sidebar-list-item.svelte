<script>
	let { item } = $props();
</script>

<a href={`${item.value}`} rel="nofollow">
	<li>
		<span>-></span>
		{item.name}
	</li>
</a>

<style>
	span {
		font-family: Fira Code;
	}
	a {
		text-decoration: none;
	}
	li {
		cursor: pointer;
		margin: 0.5em 0;
		padding: 0.5em;
		color: var(--orange);
		font-family: Noto Sans;
		border-radius: 5px;
		transition: color 0.3s ease-in-out;
		transition: background-color 0.3s ease-in-out;

		&:hover {
			color: var(--fg2);
			background-color: var(--bg2);
		}
	}
</style>
