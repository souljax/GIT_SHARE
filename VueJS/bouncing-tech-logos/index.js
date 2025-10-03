// Package entry point for npm installation
import BouncingTechLogos from './src/BouncingTechLogos.vue'

export default BouncingTechLogos
export { BouncingTechLogos }

// Auto-install when used with Vue.use()
const install = (app) => {
  app.component('BouncingTechLogos', BouncingTechLogos)
}

BouncingTechLogos.install = install

export { install }
