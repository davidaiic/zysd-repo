package com.manle.phone.android.yaodian.net

import com.drake.serialize.serialize.annotation.SerializeConfig
import com.drake.serialize.serialize.serial
import com.manle.phone.android.yaodian.bean.WebListUrlBean
import com.manle.phone.android.yaodian.util.CacheUtil


@SerializeConfig(mmapID = "net_config")
object NetUseConfig {
    var userId: String = ""
    var token: String = ""
    var isLogin: Boolean = false
    const val IMG_TEST = "https://picnew2.photophoto.cn/20080111/ziranfengjing-huanghunwanxiatupian-13389848_1.jpg"

    const val xieyi =
        "一、个人信息的收集和使用掌上药店APP收集的个人信息包括但不限于以下内容：\n ·注册信息：姓名、手机号码、电子邮件地址等。\n·身份认证信息：身份证号码、照片等。\n·医疗健康信息：病历、处方、用药记录等。\n·支付信息：银行卡信息、支付宝账户等。\n·设备信息：设备型号、操作系统版本、网络状态等。\n·日志信息：使用记录、操作行为等。\n我们收集这些信息是为了提供更好的服务，例如：\n·处理订单：我们需要收集您的姓名、地址、支付信息等来处理订单。\n·联系沟通：我们可能会使用您的电话号码或电子邮件地址与您联系，例如确认订单、处理售后等。\n·个性化推荐：我们会根据您的购买记录、浏览记录等信息，向您推荐商品或服务。\n·提高用户体验：我们会根据您的设备信息、日志信息等，优化应用程序的性能和体验。\n二、个人信息的共享和披露\n我们不会将您的个人信息出售给第三方。我们可能会将您的信息与以下第三方分享：\n·物流公司：为了处理订单和商品交付，我们需要与物流公司分享您的姓名、地址等信息。\n·支付机构：为了处理支付和退款，我们需要与支付机构分享您的支付信息。\n·合作伙伴：为了提供更好的服务，我们可能会与合作伙伴分享您的信息，例如为您提供个性化推荐等。\n·法律要求：如果法律法规或司法机关要求，我们可能需要披露您的个人信息。\n三、个人信息的保护\n·我们采取以下措施保护您的个人信息安全：\n·技术措施：我们采用加密技术、访问控制等措施保护您的个人信息安全。\n·管理制度：我们建立了相应的内部管理制度，对员工进行信息保密培训\n·安全审计：我们会定期进行安全审计和评估，确保个人信息的安全性和完整性。\n四、您的权利\n您有以下权利：\n·查看和更正：您可以查看和更正您的个人信息，确保其准确性和完整性。\n·删除：在适用法律法规允许的范围内，您可以请求删除您的个人信息。\n·关闭权限：您可以选择关闭某些服务的个人信息收集和使用权限。我们将在收到您的请求后尽快处理。\n五、隐私政策的更新\\n我们会不定期更新隐私政策，以反映我们的实践和法律要求。如果我们对隐私政策进行重大更改，我们将通过应用程序通知您。\n六、联系我们\n如果您有任何隐私问题或疑虑，请通过应用程序中提供的联系方式与我们联系\n七、其他\n本隐私政策适用于掌上药店APP。\n本隐私政策不适用于其他第三方网站或应用程序，我们无法控制这些网站或应用程序的隐私政策。"


    const val APP_ID = "wx1230384104d17ac2"


    fun changUser(token: String = "", uId: Long = 0L, isLogin: Boolean = false) {
        this.token = token
        this.userId = if (uId == 0L) "" else uId.toString()
        this.isLogin = isLogin
    }
}