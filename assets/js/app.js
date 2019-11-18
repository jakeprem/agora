import material_design_icons from 'material-design-icons/iconfont/material-icons.css'
import normalize_css from 'normalize.css'
import scss from "../css/app.scss"

import "phoenix_html"

import {Socket} from 'phoenix'
import {LiveSocket} from 'phoenix_live_view'

let liveSocket = new LiveSocket('/live', Socket)
liveSocket.connect()