<!-- footer data tpl -->

<div class="footer-data">
    <div class="icons">
        {if $pages.rss_feed}
            <a title="{$lang.subscribe_rss}" href="{getRssUrl mode='footer'}" target="_blank"><img alt="RSS Feed" src="{$rlTplBase}img/blank.gif" class="rss" /></a>
        {/if}
        <a target="_blank" title="{$lang.join_us_on_facebook}" href="{$config.facebook_page}"><img alt="facebook" src="{$rlTplBase}img/blank.gif" class="facebook" /></a>
        <a target="_blank" title="{$lang.join_us_on_twitter}" href="{$config.twitter_page}"><img alt="twitter" src="{$rlTplBase}img/blank.gif" class="twitter" /></a>
    </div>
    
    <div class="logo">
        <a href="{$rlBase}" title="{$config.site_name}">
            <img alt="{$config.site_name}" src="{$rlTplBase}img/blank.gif" />
        </a>
    </div>
    
    &copy; {$smarty.now|date_format:'%Y'}, {$lang.powered_by}
    <a title="{$lang.powered_by} {$lang.copy_rights}" href="{$lang.flynax_url}">{$lang.copy_rights}</a>
</div>

<!-- footer data tpl end -->
