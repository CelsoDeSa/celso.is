import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toasty"
// Shows the Mortal Kombat "Toasty!" easter egg on first link click
// Waits for animation to complete before proceeding with the clicked action
export default class extends Controller {
  static targets = ["toastyImage", "audio"]

  connect() {
    this.hasTriggered = false
    this.pendingNavigation = null
    this.setupClickListener()
    this.hideToasty()
  }

  disconnect() {
    this.removeClickListener()
  }

  setupClickListener() {
    this.clickHandler = this.handleLinkClick.bind(this)
    document.addEventListener("click", this.clickHandler)
  }

  removeClickListener() {
    document.removeEventListener("click", this.clickHandler)
  }

  handleLinkClick(event) {
    // If already triggered, let the click proceed normally
    if (this.hasTriggered) return

    // Check if click is on a link or button that should trigger Toasty
    const link = event.target.closest("a, button")
    if (!link) return

    // Prevent the default action
    event.preventDefault()
    event.stopPropagation()

    // Store the pending action
    this.pendingNavigation = {
      element: link,
      href: link.href,
      target: link.target
    }

    // Trigger Toasty
    this.triggerToasty()
  }

  triggerToasty() {
    if (this.hasTriggered) return

    this.hasTriggered = true
    this.playSound()
    this.showToasty()

    // Wait for Toasty animation to complete, then proceed
    setTimeout(() => {
      this.hideToasty()
      this.proceedWithNavigation()
    }, 2000)
  }

  proceedWithNavigation() {
    if (!this.pendingNavigation) return

    const { element, href, target } = this.pendingNavigation

    // Handle different types of actions
    if (element.tagName === "BUTTON") {
      // For buttons, trigger their click event again (Toasty won't block it now)
      element.click()
    } else if (href) {
      // For links, navigate
      if (target === "_blank") {
        window.open(href, "_blank")
      } else {
        window.location.href = href
      }
    }

    this.pendingNavigation = null
  }

  playSound() {
    if (this.hasAudioTarget) {
      this.audioTarget.currentTime = 0
      this.audioTarget.play().catch((error) => {
        console.log("Toasty sound playback failed:", error)
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
