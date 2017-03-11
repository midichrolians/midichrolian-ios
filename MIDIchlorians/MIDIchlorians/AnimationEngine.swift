import UIKit

class AnimationEngine: NSObject {

    static var updater: CADisplayLink!
    private static var temporaryVariableForAnimationArea: UICollectionView?
    static var animationArea: UICollectionView? {
        get { return temporaryVariableForAnimationArea }
        set { temporaryVariableForAnimationArea = newValue }
    }
    static var animationSequences = [AnimationSequence]()
    static var previousAnimatedIndexPaths = [IndexPath]()

    static func set(animationCollectionView: UICollectionView) {
        animationArea = animationCollectionView
    }

    static func register(animationSequence: AnimationSequence) {
        animationSequences.append(animationSequence)
    }

    static func clearAnimationSequenceToBeRemoved() {
        animationSequences = animationSequences.filter { !$0.toBeRemoved }
    }

    static func start() {
        updater = CADisplayLink(target: self, selector: #selector(animationLoop))
        updater.preferredFramesPerSecond = Config.animationFrequency
        updater.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }

    static func stop() {
        updater.isPaused = true
        updater.remove(from: RunLoop.current, forMode: RunLoopMode.commonModes)
        updater = nil
    }

    static func animationLoop() {
        clearAnimationSequenceToBeRemoved()
        var animationBits = [AnimationBit]()
        guard let animationCollectionView = animationArea else {
            return
        }
        for indexPath in previousAnimatedIndexPaths {
            guard let cell = animationCollectionView.cellForItem(at: indexPath) as? GridCollectionViewCell else {
                continue
            }
            cell.setAppearance()
        }
        previousAnimatedIndexPaths = [IndexPath]()
        for index in 0..<animationSequences.count {
            let animationSequence = animationSequences[index]
            guard let animationSequenceBits = animationSequence.next() else {
                animationSequence.toBeRemoved = true
                continue
            }
            animationBits.append(contentsOf: animationSequenceBits)
        }
        for animationBit in animationBits {
            let indexPath = IndexPath(item: animationBit.column, section: animationBit.row)
            guard let cell = animationCollectionView.cellForItem(at: indexPath) else {
                continue
            }
            previousAnimatedIndexPaths.append(indexPath)
            cell.backgroundColor = animationBit.colour
        }
    }
}
