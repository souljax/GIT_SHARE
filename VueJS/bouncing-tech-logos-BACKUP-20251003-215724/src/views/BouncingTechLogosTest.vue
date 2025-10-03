<template>
  <div class="test-page">
    <div class="header">
      HEADER
    </div>
    
    <div class="content">
      <div class="test-info">
        <h3>[VueJS - component : bouncing-tech-logos ]</h3>
        <p>🖱️ <strong>Hover:</strong> Pause logos</p>
        <p>🖱️ <strong>Click:</strong> Visit websites</p>
        <p>⚡ <strong>Logo & borders collisions :</strong></p>
        <p style="margin-left: 15px; font-size: 12px;">• Moving logos bounce off each other</p>
        <p style="margin-left: 15px; font-size: 12px;">• Paused logos become fixed obstacles</p>
        <p style="margin-left: 15px; font-size: 12px;">• Energy transfer on impact</p>
      </div>
      
      <BouncingTechLogos 
        :is-active="true"
        :logo-count="16"
        tooltip-text="Visit website"
        :container-bounds="{ headerHeight: 55, footerHeight: 55 }"
      />
    </div>
    
    <div class="footer">
      FOOTER
    </div>
  </div>
</template>

<script>
import BouncingTechLogos from '@/components/BouncingTechLogos.vue'

export default {
  name: 'BouncingTechLogosTest',
  components: {
    BouncingTechLogos
  }
}
</script>

<style scoped>
.test-page {
  background: #ffffff;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.header {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  z-index: 1000;
  background-color: #2e3b4e;
  color: #eee;
  height: 55px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  font-weight: bold;
  box-shadow: 0 2px 5px rgba(0,0,0,0.15);
}

.content {
  flex: 1;
  position: relative;
  overflow: hidden;
  margin-top: 55px;
  margin-bottom: 55px;
}

.test-info {
  position: fixed;
  top: 75px;
  left: 20px;
  z-index: 1000;
  background: rgba(0, 0, 0, 0.8);
  color: white;
  padding: 15px;
  border-radius: 10px;
  font-size: 14px;
}

.test-info h3 {
  margin-bottom: 10px;
  color: #4CAF50;
}

.test-info p {
  margin: 5px 0;
}

.footer {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 55px;
  background-color: #2e3b4e;
  color: #eee;
  font-size: 24px;
  font-weight: bold;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}
</style>