<!-- main menu block -->

{assign var='manu_no_match' value=false}

{strip}
    <ul class="menu">
        {foreach name='mMenu' from=$main_menu item='mainMenu'}
            {if $mainMenu.Controller == $pageInfo.Controller}
                {assign var='manu_no_match' value=true}
            {/if}

            <li {if $pageInfo.Key == $mainMenu.Key}class="active"{/if}>
                <a {if $mainMenu.No_follow || $mainMenu.Login}rel="nofollow" {/if}title="{$mainMenu.title}" href="{if $mainMenu.Page_type != 'external'}{$rlBase}{/if}{if $pageInfo.Controller != 'add_listing' && $mainMenu.Controller == 'add_listing' && !empty($category.Path) && !$category.Lock}{if $config.mod_rewrite}{$mainMenu.Path}/{$category.Path}/{$steps.plan.path}.html{else}?page={$mainMenu.Path}&amp;step={$steps.plan.path}&amp;id={$category.ID}{/if}{else}{if $mainMenu.Page_type == 'external'}{$mainMenu.Controller}{else}{if $config.mod_rewrite}{if $mainMenu.Path != ''}{$mainMenu.Path}.html{$mainMenu.Get_vars}{/if}{else}{if $mainMenu.Path != ''}?page={$mainMenu.Path}{$mainMenu.Get_vars|replace:'?':'&amp;'}{/if}{/if}{/if}{/if}">{$mainMenu.name}</a>
            </li>
        {/foreach}

        {if !$manu_no_match}
            {assign var='match_page_key' value='pages+name+'|cat:$pageInfo.Key}
            <li class="active"><a href="#">{$lang.$match_page_key}</a></li>
        {/if}
        <li class="more hide"><span><span></span><span></span><span></span></span></li>
    </ul>
{/strip}

<ul id="main_menu_more"></ul>

<!-- main menu block end -->