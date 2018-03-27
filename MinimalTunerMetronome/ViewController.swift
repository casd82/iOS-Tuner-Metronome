import UIKit

class ViewController: UIViewController {

    // MARK: Views.
    @IBOutlet weak var leftButtonView: UIButton!
    @IBOutlet weak var rightButtonView: UIButton!
    @IBOutlet weak var toggleView: ToggleView!
    @IBOutlet weak var metronomeView: MetronomeAnimationView!
    @IBOutlet weak var smallScreenView: UIImageView!
    @IBOutlet weak var tempoView: SmallScreenView!
    @IBOutlet weak var tunerView: TunerView!
    
    // MARK: Constants.
    let defaultBPM = 80
    let fastAdjustInterval = 0.2
    
    // MARK: Properties.
    weak var bpmAdjustTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shutDownMetronome()
        
        toggleView.addTarget(self, action: #selector(ViewController.toggleValueChanged(toggleView:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tempoView.positionSubviews()
        metronomeView.positionSubviews()
        toggleView.positionSubviews()
        tunerView.positionSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions.
    @IBAction func leftButtonDown(_ sender: UIButton) {
        adjustBPM(positive: false)
        invalidateBPMAdjustTimer()
        bpmAdjustTimer = Timer.scheduledTimer(withTimeInterval: fastAdjustInterval, repeats: true, block: {_ in self.fastAdjustBPM(positive: false)})
    }
    
    @IBAction func leftButtonUpInside(_ sender: UIButton) {
        invalidateBPMAdjustTimer()
    }
    
    @IBAction func leftButtonUpOutside(_ sender: UIButton) {
        invalidateBPMAdjustTimer()
    }
    
    @IBAction func rightButtonDown(_ sender: UIButton) {
        adjustBPM(positive: true)
        invalidateBPMAdjustTimer()
        bpmAdjustTimer = Timer.scheduledTimer(withTimeInterval: fastAdjustInterval, repeats: true, block: {_ in self.fastAdjustBPM(positive: true)})
    }
    @IBAction func rightButtonUpOutside(_ sender: UIButton) {
        invalidateBPMAdjustTimer()
    }
    
    @IBAction func rightButtonUpInside(_ sender: UIButton) {
        invalidateBPMAdjustTimer()
    }
    
    
    
    @objc func toggleValueChanged(toggleView: ToggleView) {
        if toggleView.inLeft {
            // Tuner.
            startUpTuner()
            shutDownMetronome()
        } else {
            // Metronome.
            shutDownTuner()
            startUpMetronome()
        }
    }
    
    // MARK: Functions.
    private func startUpMetronome() {
        leftButtonView.isHidden = false
        rightButtonView.isHidden = false
        smallScreenView.isHidden = false
        tempoView.isHidden = false
        metronomeView.isHidden = false
        
        metronomeView.startMetronome(bpm: tempoView.currTempo)
    }
    
    private func shutDownMetronome() {
        leftButtonView.isHidden = true
        rightButtonView.isHidden = true
        smallScreenView.isHidden = true
        tempoView.isHidden = true
        metronomeView.isHidden = true
        
        metronomeView.stopMetronome()
    }
    
    private func startUpTuner() {
        tunerView.isHidden = false
    }
    
    private func shutDownTuner() {
        tunerView.isHidden = true
    }
    
    private func adjustBPM(positive: Bool) {
        tempoView.changeValue(positive: positive)
        metronomeView.updateBPM(tempoView.currTempo)
    }
    
    @objc private func fastAdjustBPM(positive: Bool) {
        tempoView.changeValue(positive: positive, fastChanging: true)
        metronomeView.updateBPM(tempoView.currTempo)
    }
    
    private func invalidateBPMAdjustTimer() {
        if let timer = bpmAdjustTimer {
            timer.invalidate()
        }
    }
}

