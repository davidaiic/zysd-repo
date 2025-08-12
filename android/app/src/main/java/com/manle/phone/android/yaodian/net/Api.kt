package com.manle.phone.android.yaodian.net

import com.drake.net.request.BodyRequest
import com.drake.net.request.MediaConst
import com.google.gson.Gson
import okhttp3.RequestBody.Companion.toRequestBody

object Api {

    var APP_ID: String = "300011971395"
    var APP_KEY: String = "98747134489E853635E6554C7A1FFEB8"
    var APP_SECRET: String = "3EBABF6720854359BA3E43CCB6FAF0E8"

    const val HOST = "https://shiyao.yaojk.com.cn/"
    const val TEST = "/test"


    const val CONTET = "plugin/content"


    const val HOMEINDEX = "home/index"

    const val COMMENT_LIST = "home/commentList"

    const val comment_like="home/commentLike"

    const val hot_word="home/hotWord"

    const val home_search="home/search"

    const val home_associate_word="home/associateWord"

    const val article_list="home/articleList"

    const val  article_like="home/articleLike"

    const val  filter_criteria="home/filterCriteria"

    const val  uploadImg="plugin/upload"

    const val  comment_detail="home/commentInfo"

    const val  article_detail="home/articleInfo"

    const val  user_detail="user/center"

    const val  change_user_head="user/updateAvatar"

    const val  change_user_info="user/updateInfo"

    const val add_article_comment="home/addArticleComment"

    const val add_comment="home/addComment"

    const val user_login="user/oneLogin"


    const val article_comment_like="home/articleCommentLike"


    const val scan_code="query/scanCode"

    const val goods_server ="query/goodsServer"

    const val app_share ="plugin/appShare"

    const val web_url="plugin/webUrl"

    const val user_logout="user/logout"

    const val img_recognition="query/imageRecognition"

    const val extract_text="query/extractText"

    const val user_sendSms="user/sendSms"

    const val user_smsLogin="user/smsLogin"

    const val check_version="plugin/checkVersion"


}

fun BodyRequest.gson(vararg body: Pair<String, Any?>) {
    this.body = Gson().toJson(body.toMap()).toRequestBody(MediaConst.JSON)
}