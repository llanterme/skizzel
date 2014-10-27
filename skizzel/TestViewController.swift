
import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var uploadButton: UIButton!
    
    var squareView: UIView!
    var gravity: UIGravityBehavior!
    var animator: UIDynamicAnimator!
    var collision: UICollisionBehavior!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadButton.hidden = true;
        


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    @IBAction func triggerAnimation(sender: AnyObject) {
        
        uploadButton.hidden = false;
        
        initAnimation()
    }
    
    
    func initAnimation() {
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [uploadButton])
        animator.addBehavior(gravity)
        
        collision = UICollisionBehavior(items: [uploadButton])
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.addBoundaryWithIdentifier("barrier", fromPoint: CGPointMake(self.view.frame.origin.x, 550), toPoint: CGPointMake(self.view.frame.origin.x + self.view.frame.width, 550))
        
        animator.addBehavior(collision)

        
    }
 
}
