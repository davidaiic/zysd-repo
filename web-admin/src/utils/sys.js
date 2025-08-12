// 角色类型
export function roleType() {
  return [
    {
      'key': '1',
      'val': '系统预置'
    },
    {
      'key': '2',
      'val': '自定义'
    }
  ]
}

// 状态
export function status() {
  return [
    {
      'key': '1',
      'val': '是'
    },
    {
      'key': '0',
      'val': '否'
    }
  ]
}

// 审核状态类型
export function statusType() {
  return [
    {
      'key': '0',
      'val': '待审核'
    },
    {
      'key': '1',
      'val': '通过'
    },
    {
      'key': '2',
      'val': '拒绝'
    }
  ]
}

// banner类型
export function bannerType() {
  return [
    {
      'key': '0',
      'val': '静态'
    },
    {
      'key': '1',
      'val': 'URL跳转'
    }
  ]
}

// 状态类型
export function enableType() {
  return [
    {
      'key': '0',
      'val': '启用'
    },
    {
      'key': '1',
      'val': '禁用'
    }
  ]
}

// 价格类型
export function priceType() {
  return [
    {
      'key': '1',
      'val': '偏低'
    },
    {
      'key': '2',
      'val': '偏高'
    }
  ]
}

// 查询结果类型
export function queryResultType() {
  return [
    {
      'key': '0',
      'val': '无法识别'
    },
    {
      'key': '1',
      'val': '真'
    },
    {
      'key': '2',
      'val': '假'
    }
  ]
}

// 核查类型
export function checkType() {
  return [
    {
      'key': '0',
      'val': '待核查'
    },
    {
      'key': '1',
      'val': '核查通过'
    },
    {
      'key': '2',
      'val': '核查失败'
    }
  ]
}

// 医保类型
export function medicalType() {
  return [
    {
      'key': '0',
      'val': '无'
    },
    {
      'key': '1',
      'val': '甲类'
    },
    {
      'key': '2',
      'val': '乙类'
    }
  ]
}

// 基因靶点
export function geneTarget() {
  return [
    {
      'key': '1',
      'val': 'ALK'
    },
    {
      'key': '2',
      'val': 'EGFR'
    },
    {
      'key': '3',
      'val': 'KRAS'
    },
    {
      'key': '4',
      'val': 'MET'
    },
    {
      'key': '5',
      'val': 'RET'
    },
    {
      'key': '6',
      'val': 'ROS1'
    },
    {
      'key': '7',
      'val': 'BRAF'
    },
    {
      'key': '8',
      'val': 'NTRK'
    },
    {
      'key': '9',
      'val': '其他'
    }
  ]
}

// 药品属性
export function drugProperties() {
  return [
    {
      'key': '1',
      'val': '原研药'
    },
    {
      'key': '2',
      'val': '国产仿制药'
    },
    {
      'key': '3',
      'val': '土耳其原研药'
    },
    {
      'key': '4',
      'val': '老挝仿制药'
    },
    {
      'key': '5',
      'val': '孟加拉仿制药'
    },
    {
      'key': '6',
      'val': '印度仿制药'
    },
    {
      'key': '7',
      'val': '缅甸仿制药'
    },
    {
      'key': '8',
      'val': '巴拉圭仿制药'
    },
    {
      'key': '9',
      'val': '越南仿制药'
    },
    {
      'key': '10',
      'val': '尼泊尔仿制药'
    }
  ]
}

// 上市区域
export function marketPlace() {
  return [
    {
      'key': '0',
      'val': '无'
    },
    {
      'key': '1',
      'val': '美国上市'
    },
    {
      'key': '2',
      'val': '欧盟上市'
    },
    {
      'key': '3',
      'val': '日本上市'
    },
    {
      'key': '4',
      'val': '中国香港上市'
    },
    {
      'key': '5',
      'val': '中国大陆上市'
    }
  ]
}

// 国内临床阶段
export function clinicalStage() {
  return [
    {
      'key': '1',
      'val': '国内临床I期'
    },
    {
      'key': '2',
      'val': '国内临床II期'
    },
    {
      'key': '3',
      'val': '国内临床III期'
    }
  ]
}

// 货币类型
export function moneyType() {
  return [
    {
      'key': '0',
      'val': '人民币'
    },
    {
      'key': '1',
      'val': '美金'
    }
  ]
}

// 药品类型
export function goodsType() {
  return [
    {
      'key': '1',
      'val': '处方'
    },
    {
      'key': '2',
      'val': 'OTC'
    },
    {
      'key': '3',
      'val': '医疗器械'
    }
  ]
}

// 热门类型
export function hotType() {
  return [
    {
      'key': '0',
      'val': '非热门'
    },
    {
      'key': '1',
      'val': '国外仿制药热门'
    },
    {
      'key': '2',
      'val': '其他热门'
    }
  ]
}

// 系统类型
export function platformType() {
  return [
    {
      'key': '1',
      'val': 'android'
    },
    {
      'key': '2',
      'val': 'ios'
    }
  ]
}

// 更新类型
export function updateType() {
  return [
    {
      'key': '2',
      'val': '非强制更新'
    },
    {
      'key': '3',
      'val': '强制更新'
    }
  ]
}

// 获取上方的value
export function getVal(index, list) {
  if (index === '') return ''
  let ret = ''
  list.forEach(item => {
    if (index.toString() === item.key) {
      ret = item.val
      return false
    }
  })
  return ret
}

// 获取上方的key
export function getValue(index, list) {
  if (index === '') return ''
  let ret = ''
  list.forEach(item => {
    if (index === item.val) {
      ret = item.key
      return false
    }
  })
  return ret
}
