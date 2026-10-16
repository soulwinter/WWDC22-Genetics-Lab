import Foundation

// Original lesson copy is kept separate from experiment behavior.
enum LessonContent {
static let titles = ["First Lesson", "In Depth", "Combination Of Multiple Traits", "What Happened?", "Cultivate Your Variety"]
static let instructions = ["""
Welcome to the Genetics Lab! Here you will learn how the world's diverse organisms pass on their traits to their offspring and create a wide variety of mutations in the process.
We will explore one of the most common plants, the tomato🍅, as an example. See those question marks? They represent tomato varieties we haven't discovered yet, and at the end, we'll unlock them all!
At the very beginning, let's examine the color of the tomatoes. Tomatoes come in two color varieties, red and yellow. Have you ever thought about pollinating and crossing these two varieties? Give it a try. **Drag and drop the two tomato seeds onto both two tilled fields and tap Cross**.
""",
"""
The offspring of red and yellow tomatoes are actually only red tomatoes?! **Let's try again**, and this time we'll dive into their genetic principles together.
You may have noticed some differences. Two letters are now displayed below each seed! You'll know what they are right away!
""",
"""
Did you know that there is actually another type of tomato that looks like a pear? Suppose we call the genotype of a round tomato **[BB]**, **[Bb]** and the genotype of a pear-shaped tomato **[bb]** (yes, round is the dominant genotype)
Now, what will happen if **we cross a red round tomato with genotype [AaBb] with a yellow pear-shaped tomato with genotype [aabb]?** Let's try it!
""",
"""
You got completely different tomato varieties from their parents by the experiment you just did! Bravo!
Now, let's look at how this was done. Do it again.
""",
"""
You've learned the most basic and important principles of genetics! Now it's time to create your own variety of tomato!
We have now discovered a gene in tomatoes that affects its susceptibility to insect pests, and we call the genotypes that have pest resistance **[CC]**, **[Cc]** and the ones that are susceptible to pests **[cc]**.
Now we have three plants **[AAbbcc]**, **[aaBBcc]**, **[aabbCC]**. Can you get all the unknown varieties of tomatoes through them?
You can do this through multiple crosses, so give it a try! Note that since tomatoes can only produce 40-150 fruits in one cross, you may not get all possible genotypes at a time.
"""


]

static let animations = [["""
As shown below, in general, the trait of an organism is represented by a pair of letters called *hereditary factor*.
In our example, the color of a tomato can be represented by **[AA], [Aa] or [aa]**. **[AA] and [Aa]** both represent red, while **[aa]** represents yellow.
The variety that account for a large proportion are called *dominant trait*, and the other is called  *recessive trait*. In this case, red is the dominant trait. And this pair of letters we call it *genotype*.
""",
"""
It's plant pollen production time! The three pairs of tiny yellow circles are the pollen produced by the female plant and the anthers produced by the male plant that we found at random. Each pollen or anther also contains a letter (hereditary factor), and this hereditary factor is randomly drawn from the genotype of the original plant.
""",
"""
After bees and other insects pollinate these flowers, the pollen and anthers merge to become seeds. Their respective hereditary factors thus converge to become the genotype of the plant that the seeds will become! So all the seeds just now will become red tomatoes of type **[Aa]**!
""",
"""
And as just said, **[Aa]** stands for red tomato. So, the offspring of **[AA]** tomatoes and **[aa]** tomatoes are all **[Aa]** red tomatoes!
"""
],
["Again, let's show the genotypes of the plants on the screen. What kind of pollen and anthers do you think they will produce?",
"""
We found three more random pairs of pollen and anthers.
Did you notice the change? The red tomato **[AaBb]** plant produced pollen by first selecting one at random from **[Aa]** and then one at random from **[Bb]**. Thus, it may produce four gametes **[AB]**, **[Ab]**, **[aB]**, **[ab]**.
Next, It will then combine with **[ab]** of the **[aabb]** yellow plant (yellow plants can only produce this one anther!).
""",
"""
We found three more random pairs of pollen and anthers.
Did you notice the change? The red tomato **[AaBb]** plant produced pollen by first selecting one at random from **[Aa]** and then one at random from **[Bb]**. Thus, it may produce four *gametes* **[AB]**, **[Ab]**, **[aB]**, **[ab]**.
Next, It will then combine with **[ab]** of the **[aabb]** yellow plant (yellow plants can only produce this one anther!).
""",
"""
Genetics is just so amazing! Through hybridization, we can obtain a wide variety of plant types. In the next section, you'll be able to try to create your own!
"""]]

}
