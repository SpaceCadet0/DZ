<?php

/******************************************************************************
 *  
 *  PROJECT: Flynax Classifieds Software
 *  VERSION: 4.8.0
 *  LICENSE: RU9018RLF896 - https://www.flynax.ru/user-agreement.html
 *  PRODUCT: Real Estate Classifieds
 *  DOMAIN: domozhil.ru
 *  FILE: INDEX.PHP
 *  
 *  The software is a commercial product delivered under single, non-exclusive,
 *  non-transferable license for one domain or IP address. Therefore distribution,
 *  sale or transfer of the file in whole or in part without permission of Flynax
 *  respective owners is considered to be illegal and breach of Flynax License End
 *  User Agreement.
 *  
 *  You are not allowed to remove this information from the file without permission
 *  of Flynax respective owners.
 *  
 *  Flynax Classifieds Software 2020 | All copyrights reserved.
 *  
 *  https://www.flynax.ru
 ******************************************************************************/

use Flynax\Utils\Util;

if (!defined('IS_LOGIN')) {
    // clear saved referer if the referer changed
    if ($_SESSION['login_referer'] && $page_info['prev'] != $page_info['Key']) {
        unset($_SESSION['login_referer']);
    }

    if (isset($_POST['action']) && $_POST['action'] == 'login') {
        $username = $_POST['username'];
        $password = $_POST['password'];
        $remember_me = $_POST['remember_me'];

        if (true === $res = $rlAccount->login($username, $password, false, $remember_me)) {
            // Remove logout handler from URL for logged user
            if (false !== strpos($_SERVER['HTTP_REFERER'], '?logout')) {
                $_SESSION['remove_logout_handler'] = true;
            }

            $reefless->loadClass('Notice');
            $rlNotice->saveNotice($lang['notice_logged_in']);

            $rlHook->load('loginSuccess');

            if ($_SESSION['login_referer']) {
                $referer = $_SESSION['login_referer'];
                unset($_SESSION['login_referer']);
                $reefless->redirect(null, $referer);
            } else {
                if ($page_info['prev'] && in_array($page_info['prev'], array('login', 'remind', 'registration'))) {
                    if ($account_info['Lang'] && $account_info['Lang'] != $config['lang']) {
                        $url = RL_URL_HOME . $account_info['Lang'] . "/";
                    } else {
                        $url = SEO_BASE;
                    }

                    $url .= $config['mod_rewrite'] ? $pages['login'] . '.html' : '?page=' . $pages['login'];

                    Util::redirect($url);
                } elseif ($account_info['Lang'] && $account_info['Lang'] != RL_LANG_CODE && $languages[$account_info['Lang']]) {
                    $reefless->referer(null, RL_LANG_CODE, $account_info['Lang']);
                } else {
                    $reefless->referer();
                }
            }
        } else {
            // save referer
            if (!$_SESSION['login_referer'] && is_numeric(strpos($_SERVER['HTTP_REFERER'], RL_URL_HOME))) {
                $_SESSION['login_referer'] = $_SERVER['HTTP_REFERER'];
            }

            // login page mode
            if ($page_info['prev'] == 'login') {
                if ($rlAccount->messageType == 'error') {
                    $rlSmarty->assign_by_ref('errors', $res);
                } else {
                    $rlSmarty->assign_by_ref('pAlert', $res[0]);
                }
            }
            // remote pages mode
            else {
                $reefless->loadClass('Notice');
                $rlNotice->saveNotice($res, 'error');

                $url = SEO_BASE;
                $url .= $config['mod_rewrite'] ? $pages['login'] . '.html' : '?page=' . $pages['login'];
                $reefless->redirect(null, $url);
            }
        }
    }
} else {
    if (isset($_GET['action']) && $_GET['action'] == 'logout') {
        $rlAccount->logOut();
    }
    $page_info['name'] = $lang['blocks+name+account_area'];
}
