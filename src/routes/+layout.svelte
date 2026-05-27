<script>
	import Footer from '$lib/components/footer.svelte';
	import Header from '$lib/components/header.svelte';
	import Sidebar from '$lib/components/sidebar.svelte';

	let { children } = $props();
	let collapsed = $state(false);
</script>

<svelte:head>
	<title>Devtools | German III</title>
</svelte:head>

<main class="layout">
	<Header />

	<div class="layout-container">
		<Sidebar collapsed={collapsed} ontoggle={() => collapsed = !collapsed} />
		<div class="page-content">
			{@render children()}
		</div>
	</div>

	<Footer />
</main>

<style>
	.layout {
		height: 100vh;
		display: grid;
		grid-template-rows: auto 1fr auto;
	}

	.layout-container {
		display: flex;
		flex-direction: row;
		background: var(--background);
		height: 100%;
		min-height: 0;
	}

	.page-content {
		flex-grow: 1;
		overflow-y: auto;
		background: var(--background);
		color: var(--text);
		margin: 1em;
	}
</style>
