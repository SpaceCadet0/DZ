	<footer class="clearfix">
		<div class="point1 clearfix">
			<nav class="footer-menu">
				{include file='menus'|cat:$smarty.const.RL_DS|cat:'footer_menu.tpl'}
			</nav>
			
			{include file='footer_data.tpl'}
		</div>
	</footer>

	{if !$isLogin}
		<div id="login_modal_source" class="hide">
			<div class="tmp-dom">
				{include file='blocks'|cat:$smarty.const.RL_DS|cat:'login_modal.tpl'}
			</div>
		</div>
	{/if}
		
	{rlHook name='tplFooter'}
	
	{displayCSS mode='footer'}

	{displayJS}
</body>
</html>
