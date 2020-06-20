---
layout: search
title: Finder
comments: false
---

<!-- HTML elements for search -->
<input class="container content" type="text" id="search-input" placeholder="Search blog posts..">
<ul id="results-container"></ul>

<script src="{{ site.baseurl }}/js/simple-jekyll-search.min.js"></script>

<script>
  window.simpleJekyllSearch = new SimpleJekyllSearch({
    searchInput: document.getElementById('search-input'),
    resultsContainer: document.getElementById('results-container'),
    json: '{{ site.baseurl }}/search.json',
    searchResultTemplate: '<li><a href="{url}?query={query}" title="{desc}">{title}</a></li>',
    noResultsText: 'No results found',
    limit: 10,
    fuzzy: false,
    exclude: ['Welcome']
  })
</script>