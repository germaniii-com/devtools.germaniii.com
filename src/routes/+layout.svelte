<script>
	import { Footer, Header, Sidebar } from '$lib/components';
	import { fade } from 'svelte/transition';

	let { children, data } = $props();
</script>

<main>
	<Header />
	<div class="content">
		<Sidebar />
		<div class="page-content">
			{#key data.pathname}
				<div in:fade={{ duration: 300, delay: 400 }} out:fade={{ duration: 300 }}>
					{@render children()}
				</div>
			{/key}
		</div>
	</div>
	<Footer />
</main>

<style>
	main {
		display: grid;
		grid-template-rows: 5vh 90vh 5vh;
		background-color: var(--bg);
		color: var(--fg);
	}
	.content {
		display: grid;
		grid-template-columns: 15vw 85vw;
		max-height: 90vh;
	}
	.page-content {
		display: block;
		height: 100%;
		padding: 1em;
		overflow-y: auto;
	}
</style>
