import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toasty"
// Shows the Mortal Kombat "Toasty!" easter egg when scrolling down on the page
export default class extends Controller {
  static targets = ["toastyImage", "audio"]
  static values = {
    threshold: { type: Number, default: 0.9 }
  }

  connect() {
    this.hasTriggered = false
    this.setupScrollListener()
    this.hideToasty()
  }

  disconnect() {
    this.removeScrollListener()
  }

  setupScrollListener() {
    this.scrollHandler = this.checkScroll.bind(this)
    window.addEventListener("scroll", this.scrollHandler, { passive: true })
  }

  removeScrollListener() {
    window.removeEventListener("scroll", this.scrollHandler)
  }

  checkScroll() {
    if (this.hasTriggered) return

    const scrollTop = window.scrollY || window.pageYOffset
    const docHeight = document.documentElement.scrollHeight - window.innerHeight
    const scrollPercent = scrollTop / docHeight

    if (scrollPercent >= this.thresholdValue) {
      this.triggerToasty()
    }
  }

  triggerToasty() {
    this.hasTriggered = true
    this.playSound()
    this.showToasty()
    
    // Auto-hide after animation completes
    setTimeout(() => {
      this.hideToasty()
    }, 2000)
  }

  playSound() {
    if (this.hasAudioTarget) {
      this.audioTarget.currentTime = 0
      this.audioTarget.play().catch(() => {
        // Audio play failed (likely due to user interaction requirement)
        console.log("Toasty sound playback requires user interaction first")
      })
    }
  }

  showToasty() {
    if (this.hasToastyImageTarget) {
      this.toastyImageTarget.classList.remove("translate-y-full", "opacity-0")
      this.toastyImageTarget.classList.add("translate-y-0", "opacity-100")
    }
  }

  hideToasty() {
    if (this.hasToastyImageTarget) {
      this.toastyImageTarget.classList.remove("translate-y-0", "opacity-100")
      this.toastyImageTarget.classList.add("translate-y-full", "opacity-0")
    }
  }
}
