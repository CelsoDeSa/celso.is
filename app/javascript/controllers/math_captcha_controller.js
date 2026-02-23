import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="math-captcha"
export default class extends Controller {
  static targets = ["trigger", "emailLink", "modal", "modalContent", "question", "input", "errorMsg"]

  connect() {
    this.answer = 0
  }

  generateQuestion() {
    const operations = ['+', '-', '*', '/']
    const op = operations[Math.floor(Math.random() * operations.length)]
    let a, b

    switch (op) {
      case '+':
        a = Math.floor(Math.random() * 20) + 1
        b = Math.floor(Math.random() * 20) + 1
        this.answer = a + b
        break
      case '-':
        a = Math.floor(Math.random() * 20) + 10
        b = Math.floor(Math.random() * a) // ensure positive result
        this.answer = a - b
        break
      case '*':
        a = Math.floor(Math.random() * 9) + 2
        b = Math.floor(Math.random() * 9) + 2
        this.answer = a * b
        break
      case '/':
        b = Math.floor(Math.random() * 9) + 2
        this.answer = Math.floor(Math.random() * 9) + 2
        a = this.answer * b // ensure perfectly divisible numbers
        break
    }

    this.questionTarget.textContent = `${a} ${op} ${b}`
  }

  openModal(e) {
    if (e) e.preventDefault()
    this.generateQuestion()
    this.inputTarget.value = ''
    this.errorMsgTarget.classList.add("hidden")
    this.inputTarget.classList.remove("border-red-500")

    // Hide scrolling on the body while modal is open
    document.body.style.overflow = "hidden"

    // Show modal
    this.modalTarget.classList.remove("hidden")

    // Animate in
    requestAnimationFrame(() => {
      this.modalTarget.classList.remove("opacity-0")
      this.modalContentTarget.classList.remove("scale-95")
      this.modalContentTarget.classList.add("scale-100")
    })

    // Focus input slightly after animation has started
    setTimeout(() => {
      this.inputTarget.focus()
    }, 100)
  }

  closeModal(e) {
    if (e) e.preventDefault()

    // Restore scrolling
    document.body.style.overflow = "auto"

    this.modalTarget.classList.add("opacity-0")
    this.modalContentTarget.classList.remove("scale-100")
    this.modalContentTarget.classList.add("scale-95")

    setTimeout(() => {
      this.modalTarget.classList.add("hidden")
    }, 300)
  }

  checkAnswer(e) {
    this.errorMsgTarget.classList.add("hidden")
    this.inputTarget.classList.remove("border-red-500")

    const valStr = this.inputTarget.value.trim()
    if (valStr === '') return

    const val = parseInt(valStr)

    // Check if what they typed matches the answer exactly
    if (val === this.answer) {
      this.success()
    } else if (valStr.length >= this.answer.toString().length) {
      // Show error only if they typed enough digits to be wrong
      this.errorMsgTarget.classList.remove("hidden")
      this.inputTarget.classList.add("border-red-500")
    }
  }

  success() {
    this.closeModal()

    // Hide trigger button
    this.triggerTarget.classList.add("hidden")

    // Show email link initially transparent and scaled down
    this.emailLinkTarget.classList.remove("hidden")

    // Animate email link into final state
    requestAnimationFrame(() => {
      this.emailLinkTarget.classList.remove("opacity-0", "scale-95")
      this.emailLinkTarget.classList.add("opacity-100", "scale-100")
    })
  }
}
