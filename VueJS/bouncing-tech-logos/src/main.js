import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import App from './App.vue'
import BouncingTechLogosTest from './views/BouncingTechLogosTest.vue'

const routes = [
  {
    path: '/',
    redirect: '/bouncing-tech-logos-test'
  },
  {
    path: '/bouncing-tech-logos-test',
    name: 'BouncingTechLogosTest',
    component: BouncingTechLogosTest
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

const app = createApp(App)
app.use(router)
app.mount('#app')