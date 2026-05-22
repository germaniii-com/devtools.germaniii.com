import { writable } from 'svelte/store';

export const themes = {
	light: 'light',
	dark: 'dark'
};

export const theme = writable('light');

if (typeof window !== 'undefined') {
	const saved = localStorage.getItem('theme');
	const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
	const initial = saved || (prefersDark ? 'dark' : 'light');
	theme.set(initial);
	document.documentElement.setAttribute('data-theme', initial);

	theme.subscribe((value) => {
		localStorage.setItem('theme', value);
		document.documentElement.setAttribute('data-theme', value);
	});
}
