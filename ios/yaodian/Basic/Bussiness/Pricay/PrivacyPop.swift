//
//  PrivacyPop.swift
//  Basic
//
//  Created by wangteng on 2023/3/5.
//

import Foundation
import Bind

class PrivacyPop {
    
    static let shared = PrivacyPop()
    
    enum PrivacyType: Int {
        case yhxy
        case yszc
        case userInfo
        case third
        
        var identify: String {
            switch self {
            case .yhxy: return "0"
            case .yszc: return "1"
            case .userInfo: return "2"
            case .third: return "3"
            }
        }
        
        var title: String {
            switch self {
            case .yhxy: return "用户协议"
            case .yszc: return "隐私政策"
            case .userInfo: return "个人信息收集清单"
            case .third: return "第三方信息共享清单"
            }
        }
        
        var webPath: String {
            switch self {
            case .yhxy: return "protocol"
            case .yszc: return "privacy"
            case .userInfo: return "basicUserInfo"
            case .third: return "third"
            }
        }
    }
    
    @UserDefaultsWrapper(key: "privacy.pop.has.show")
    var hasPrivacy: Bool?
    
    func canShow() -> Bool {
        if let hasPrivacy = self.hasPrivacy, hasPrivacy {
            return false
        }
        return true
    }
    
    func show() {

        let attributedText = NSMutableAttributedString(string: "欢迎您使用掌上药店！")
            .bind.font(.systemFont(ofSize: 14, weight: .medium))
            .foregroundColor(UIColor(0x333333))
            .base
        
        let attributedPrivacyText = NSMutableAttributedString(string:"一、个人信息的收集和使用掌上药店APP收集的个人信息包括但不限于以下内容：\n ·注册信息：姓名、手机号码、电子邮件地址等。\n·身份认证信息：身份证号码、照片等。\n·医疗健康信息：病历、处方、用药记录等。\n·支付信息：银行卡信息、支付宝账户等。\n·设备信息：设备型号、操作系统版本、网络状态等。\n·日志信息：使用记录、操作行为等。\n我们收集这些信息是为了提供更好的服务，例如：\n·处理订单：我们需要收集您的姓名、地址、支付信息等来处理订单。\n·联系沟通：我们可能会使用您的电话号码或电子邮件地址与您联系，例如确认订单、处理售后等。\n·个性化推荐：我们会根据您的购买记录、浏览记录等信息，向您推荐商品或服务。\n·提高用户体验：我们会根据您的设备信息、日志信息等，优化应用程序的性能和体验。\n二、个人信息的共享和披露\n我们不会将您的个人信息出售给第三方。我们可能会将您的信息与以下第三方分享：\n·物流公司：为了处理订单和商品交付，我们需要与物流公司分享您的姓名、地址等信息。\n·支付机构：为了处理支付和退款，我们需要与支付机构分享您的支付信息。\n·合作伙伴：为了提供更好的服务，我们可能会与合作伙伴分享您的信息，例如为您提供个性化推荐等。\n·法律要求：如果法律法规或司法机关要求，我们可能需要披露您的个人信息。\n三、个人信息的保护\n·我们采取以下措施保护您的个人信息安全：\n·技术措施：我们采用加密技术、访问控制等措施保护您的个人信息安全。\n·管理制度：我们建立了相应的内部管理制度，对员工进行信息保密培训\n·安全审计：我们会定期进行安全审计和评估，确保个人信息的安全性和完整性。\n四、您的权利\n您有以下权利：\n·查看和更正：您可以查看和更正您的个人信息，确保其准确性和完整性。\n·删除：在适用法律法规允许的范围内，您可以请求删除您的个人信息。\n·关闭权限：您可以选择关闭某些服务的个人信息收集和使用权限。我们将在收到您的请求后尽快处理。\n五、隐私政策的更新\n我们会不定期更新隐私政策，以反映我们的实践和法律要求。如果我们对隐私政策进行重大更改，我们将通过应用程序通知您。\n六、联系我们\n如果您有任何隐私问题或疑虑，请通过应用程序中提供的联系方式与我们联系\n七、其他\n本隐私政策适用于掌上药店APP。\n本隐私政策不适用于其他第三方网站或应用程序，我们无法控制这些网站或应用程序的隐私政策。")
            .bind
            .font(.systemFont(ofSize: 14))
            .foregroundColor(UIColor(0x666666))
            .base
        
        let messageAttributed = {
            return NSMutableAttributedString(string: "如您同意")
                .bind
                .font(.systemFont(ofSize: 14, weight: .medium))
                .foregroundColor(UIColor(0x333333))
                .attributedString(.init(string: "《用户协议》")
                    .bind
                    .font(.systemFont(ofSize: 14, weight: .medium))
                    .foregroundColor(.barTintColor)
                    .link(PrivacyType.yhxy.identify, .barTintColor)
                    .base)
                .attributedString(.init(string: "《隐私政策》")
                    .bind
                    .font(.systemFont(ofSize: 14, weight: .medium))
                    .foregroundColor(.barTintColor)
                    .link(PrivacyType.yszc.identify, .barTintColor)
                    .base)
                .attributedString(.init(string: "《个人信息收集清单》")
                    .bind
                    .font(.systemFont(ofSize: 14, weight: .medium))
                    .foregroundColor(.barTintColor)
                    .link(PrivacyType.userInfo.identify, .barTintColor)
                    .base)
                .attributedString(.init(string: "以及")
                    .bind
                    .font(.systemFont(ofSize: 14, weight: .medium))
                    .foregroundColor(UIColor(0x333333))
                    .base)
                .attributedString(.init(string: "《第三方信息共享清单》")
                    .bind
                    .font(.systemFont(ofSize: 14, weight: .medium))
                    .foregroundColor(.barTintColor)
                    .link(PrivacyType.third.identify, .barTintColor)
                    .base)
                .attributedString(.init(string: "请点击\"同意并继续\"按钮开启我们的服务")
                    .bind
                    .font(.systemFont(ofSize: 14, weight: .medium))
                    .foregroundColor(UIColor(0x333333))
                    .base)
                .base
        }
        
        
        let popManager = BasicPopManager()
            .bind(.spacing(10))
            .bind(.title("隐私保护说明", {
                $0.attributedText.bind.font(.systemFont(ofSize: 18, weight: .semibold))
            }))
            .bind(.attributedTitle(attributedText, {
                $0.textAlignment = .left
            }))
            .bind(.attributedTitle(attributedPrivacyText, {
                $0.textAlignment = .left
            }))
            .bind(.attributedMessage(messageAttributed(), {
                $0.linkHandler = { (link, _) -> Bool in
                    let privacy = PrivacyType(rawValue: link.bind.integerValue) ?? .yszc
                    PrivacyWebViewController(privacyType: privacy).bind.push()
                    return true
                }
                $0.textAlignment = .left
            }))
            .action(titles: ["同意并继续 ", "不同意"], handler: { action in
                action.handler = { selectedIndex -> Bool in
                    if selectedIndex == 0 {
                        self.hasPrivacy = true
                        return true
                    } else {
                        exit(0)
                    }
                }
                action.configureHandler = { btn in
                    if btn.tag == 1 {
                        btn.backgroundColor = UIColor(0xF2F3F5)
                        btn.setTitleColor(UIColor(0x666666), for: .normal)
                    }
                }
                action.direction = .vertical
            })
        
        let contentView = BasicPopContentView(configuration: popManager.config)
        let popup = Popup(contentView: contentView)
        popManager.config.closeHandler = {
            popup.dismiss()
        }
        popup.show(.center)
    }
}
