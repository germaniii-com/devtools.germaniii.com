<script>
	import Heading from './heading.svelte';
	import pages from '../constants/pages';
</script>

<nav>
	<Heading level={2}>Sidebar</Heading>
	<ul>
		{#each pages as page (page)}
			<li>
				{page}
			</li>
		{/each}
	</ul>
</nav>

<style>
	nav {
		height: 100%;
		padding: 1em;
	}
</style>
