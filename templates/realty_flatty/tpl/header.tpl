{include file='head.tpl'}

	<header>
		<section class="point1">
			<div id="logo">
				<a href="{$rlBase}" title="{$config.site_name}">
					<img alt="{$config.site_name}" 
                        src="{$rlTplBase}img/logo.png" 
                        srcset="{$rlTplBase}img/@2x/logo.png 2x" />
				</a>
			</div>
			
			{if $config.header_banner_space && $pageInfo.Key != 'search_on_map'}
			<div id="header-banner">
				{include file='blocks'|cat:$smarty.const.RL_DS|cat:'header_banner.tpl'}
			</div>
			{/if}

			<div id="top-navigation" class="clearfix">
				{rlHook name='tplHeaderUserNav'}
				
				{if $pages.login}
				{include file='blocks'|cat:$smarty.const.RL_DS|cat:'user_navbar.tpl'}
				{/if}
				{include file='blocks'|cat:$smarty.const.RL_DS|cat:'lang_selector.tpl'}				
			</div>
		</section>
		<section class="main-menu">
			<nav class="point1 clearfix">
				<div class="kw-search">
					{strip}
					<span class="lens"><span></span></span>
				 	<span class="field">
						<form method="post" action="{$rlBase}{if $config.mod_rewrite}{$pages.search}.html{else}?page={$pages.search}{/if}">
							<input type="hidden" name="form" value="keyword_search" />
							{assign var='ks_phrase' value='blocks+name+keyword_search'}
							<input placeholder="{$lang.$ks_phrase}" id="autocomplete" type="text" maxlength="255" name="f[keyword_search]" {if $smarty.post.f.keyword_search}value="{$smarty.post.f.keyword_search}"{/if}/>
						</form>
					</span>
					{/strip}
					<span class="close"></span>
					
					<script>
						var view_details = '{$lang.view_details}';
						var join_date = '{$lang.join_date}';
						var category_phrase = '{$lang.category}';
					</script>
				</div>
				{include file='menus'|cat:$smarty.const.RL_DS|cat:'main_menu.tpl'}
			</nav>
		</section>
	</header>
