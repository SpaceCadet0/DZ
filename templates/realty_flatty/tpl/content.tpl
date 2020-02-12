<!-- page content -->

{assign var='featured_gallary' value=false}

<div id="wrapper">
	<div id="push-header"></div>
	
	<section id="main_container">
		{include file='blocks'|cat:$smarty.const.RL_DS|cat:'bread_crumbs.tpl'}

		<div class="inside-container point1 clearfix">
			{if $pageInfo.Key == 'home'}
				{include file='blocks'|cat:$smarty.const.RL_DS|cat:'home_content.tpl'}
			{/if}

			<div class="row">
    			<!-- sidebar area -->
    			{if $blocks.left && $pageInfo.Controller != 'listing_details' && $pageInfo.Key != 'search_on_map'}
    				<aside class="left col-md-{if $pageInfo.Key == 'home' || $pageInfo.Controller == 'listing_details' || !$blocks.left}12{else}4{/if}">
    				{strip}
    				{foreach from=$blocks item='block'}
    				{if $block.Side == 'left'}
    					{include file='blocks'|cat:$smarty.const.RL_DS|cat:'blocks_manager.tpl' block=$block}
    				{/if}
    				{/foreach}
    				{/strip}
    				</aside>
    			{/if}
    			<!-- sidebar area end -->

				<!-- content area -->
				<section id="content" class="col-md-{if ($pageInfo.Key == 'home' || $pageInfo.Controller == 'listing_details' || $pageInfo.Key == 'search_on_map' || !$blocks.left)}12{else}8{/if} col-sm-12">
					{if $pageInfo.Key != 'home' && !$no_h1}
						{if $navIcons}
							<div class="h1-nav">
								<nav id="content_nav_icons">
									{rlHook name='pageNavIcons'}
									
									{if !empty($navIcons)}
										{foreach from=$navIcons item='icon'}
											{$icon}
										{/foreach}
									{/if}
								</nav>	
						{/if}

							<h1>{if $pageInfo.h1}{$pageInfo.h1}{else}{$pageInfo.name}{/if}</h1>

						{if $navIcons}
							</div>
						{/if}
					{/if}

					<div id="system_message">
                        {if $errors || $pNotice || $pAlert}
                            <script class="fl-js-dynamic">
                                var fixed_message = {if $fixed_message}false{else}true{/if};
                                var message_text = '', error_fields = '';
                                var message_type = 'error';
                                {if isset($errors)}
                                    error_fields = {if $error_fields}'{$error_fields|escape:"javascript"}'{else}false{/if};
                                    message_text += '<ul>';
                                    {foreach from=$errors item='error'}message_text += '<li>{$error|regex_replace:"/[\r\t\n]/":"<br />"|escape:"javascript"}</li>';{/foreach}
                                    message_text += '</ul>';
                                {/if}
                                {if isset($pNotice)}
                                    message_text = '{$pNotice|escape:"javascript"}';
                                    message_type = 'notice';
                                {/if}
                                {if isset($pAlert)}
                                    var message_text = '{$pAlert|escape:"javascript"}';
                                    message_type = 'warning';
                                {/if}
                                {literal}
                                $(document).ready(function(){
                                    if (message_text) {
                                        printMessage(message_type, message_text, error_fields, fixed_message);
                                    }
                                });
                            {/literal}</script>
                        {/if}

					<!-- no javascript mode -->
					{if !$smarty.const.IS_BOT}
					<noscript>
					<div class="warning">
						<div class="inner">
							<div class="icon"></div>
							<div class="message">{$lang.no_javascript_warning}</div>
						</div>
					</div>
					</noscript>
					{/if}
					<!-- no javascript mode end -->
				</div>
				
				{if $blocks.top && $pageInfo.Key != 'search_on_map'}
				<!-- top blocks area -->
				<aside class="top">
					{foreach from=$blocks item='block'}
					{if $block.Side == 'top'}
						{include file='blocks'|cat:$smarty.const.RL_DS|cat:'blocks_manager.tpl' block=$block}
					{/if}
					{/foreach}
				<!-- top blocks area end -->
				</aside>
				{/if}
				
				<section id="controller_area">{strip}
					{if $pageInfo.Page_type == 'system'}
						{include file=$content}
					{else}
						<div class="content-padding">{$staticContent}</div>
					{/if}
				{/strip}</section>
				
				<!-- middle blocks area -->
				{if $blocks.middle && $pageInfo.Controller != 'listing_details' && $pageInfo.Key != 'search_on_map'}
				<aside class="middle">
					{foreach from=$blocks item='block'}
						{if $block.Side == 'middle'}
							{include file='blocks'|cat:$smarty.const.RL_DS|cat:'blocks_manager.tpl' block=$block}
						{/if}
					{/foreach}
				</aside>
				{/if}
				<!-- middle blocks area end -->
				
				{if ($blocks.middle_left || $blocks.middle_right) && $pageInfo.Key != 'search_on_map'}
				<!-- middle blocks area -->
					<aside class="{if $blocks.middle && $pageInfo.Key == 'home'}three{else}two{/if}-middle row">
						<div class="col-md-{if $blocks.middle && $pageInfo.Key == 'home'}4{else}6{/if} col-sm-6">
							{foreach from=$blocks item='block'}
							{if $block.Side == 'middle_left'}
								{include file='blocks'|cat:$smarty.const.RL_DS|cat:'blocks_manager.tpl' block=$block}
							{/if}
							{/foreach}
						</div>
					
						{if $blocks.middle && $pageInfo.Key == 'home'}<div class="middle-center col-md-4 col-sm-6"></div>{/if}
					
						<div class="col-md-{if $blocks.middle && $pageInfo.Key == 'home'}4{else}6{/if} col-sm-6">
							{foreach from=$blocks item='block'}
							{if $block.Side == 'middle_right'}
								{include file='blocks'|cat:$smarty.const.RL_DS|cat:'blocks_manager.tpl' block=$block}
							{/if}
							{/foreach}
						</div>
				</aside>
				<!-- middle blocks area end -->
				{/if}
				
				{if $blocks.bottom && $pageInfo.Key != 'search_on_map'}
				<!-- bottom blocks area -->
				<aside class="bottom">
					{foreach from=$blocks item='block'}
					{if $block.Side == 'bottom'}
						{include file='blocks'|cat:$smarty.const.RL_DS|cat:'blocks_manager.tpl' block=$block}
					{/if}
					{/foreach}
				</aside>
				<!-- bottom blocks area end -->
				{/if}
			</section>
				<!-- content area -->
		</div>
		</div>

	</section>
	
	<div id="push-footer"></div>
</div>

<!-- page content end -->
