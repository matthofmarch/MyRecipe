using System;
using System.Collections.Generic;
using System.Text;

namespace Core.Model.Response
{
    public class MealDtoList
    {
        public MealDtoList(MealDto[] proposedMeals)
        {
            ProposedMeals = proposedMeals;
        }

        public MealDto[] ProposedMeals { get; set; }
    }
}
