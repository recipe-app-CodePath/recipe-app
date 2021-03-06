import UIKit
import Alamofire


let headers = [
    "X-Mashape-Key": "NHDnizUDH5mshbK6fNDHtFJAQRpDp1zYm3FjsnAVFgzGtVfsXi",
    "Accept": "application/json"
]



class RecipeFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    //var feed: [NSDictionary]?
    var ingredients: [String]!
    var recipes: [Recipe]!
        override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
        
        recipeTableView.rowHeight = UITableViewAutomaticDimension
        recipeTableView.estimatedRowHeight = 120
        
        // Parameters
        var ingredients_str = ""
        //let limitLicense = false
        //let number = 4
        //let ranking = 1
        
        
        
        
        if let ingredients = ingredients {
            print(ingredients)
            
            for ingre in ingredients {
                ingredients_str += "\(ingre),"
            }
            
            let requestUrl = NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients?ingredients=\(ingredients_str)")
            
//            let requestUrl = NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/648715/summary")
            
            
            // API Request
            Alamofire.request(.GET, requestUrl!, headers: headers, encoding: .JSON).responseJSON {
                response in switch response.result {
                    
                    //API Response
                case .Success:
                    // JSON is retrieved
                    
                    //print("\(response.result.value!)")
                    self.recipes = Recipe.recipesWithArray(response.result.value! as! [NSDictionary])
                    // Now the issue is with loading the data we get into our recipes array. Uncomment both lines below to see error.
                    //self.recipes = response.result.value! as! [Recipe]
                    //print("\(self.recipes!)")
                    
                    print("-------------------")
                    for recipe in self.recipes {
                        print(recipe.title)
                    }
                    
                    self.recipeTableView.reloadData()
                case .Failure:
                    print("\(response.description)")
                    print("Request failed with error:")
                }
            }
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recipes != nil {
            return recipes.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = recipeTableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath) as! RecipeCell
        
        //let recipe = recipes![indexPath.row]
        cell.recipe = recipes[indexPath.row]
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        let cell = sender as! UITableViewCell
        
        let indexPath = recipeTableView.indexPathForCell(cell)
        
        
        
        let food = feed![indexPath!.row]
        
        let recipeViewController = segue.destinationViewController as? RecipeViewController
        
        recipeViewController!.food =/Users/user/Desktop/Recipe-App food */
        
        let cell = sender as! UITableViewCell
        if let indexPath = recipeTableView.indexPathForCell(cell), recipes = recipes {
            print(indexPath)
            let recipe = recipes[indexPath.row]
            if let recipeViewController = segue.destinationViewController as? RecipeViewController {
                recipeViewController.recipe = recipe
            }
            
            
        }
        
        
        print("Prepare for segue")
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
    
    
    
}
