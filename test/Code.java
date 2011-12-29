package myth.zomato.tweeter.server;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger; //kinda sucks

import myth.zomato.tweeter.client.service.ListService;
import myth.zomato.tweeter.shared.TweeterList;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.Query;
import com.google.gwt.user.server.rpc.RemoteServiceServlet;

/* Well these comments should be part of the final code*/

/*These comments also
 are not relevant to codealiker
 */

/*I hate
 these comments baby */

public class Code extends RemoteServiceServlet implements ListService
{
	private List<TweeterList> listoflist=new ArrayList<TweeterList>();
	private DatastoreService datastore =DatastoreServiceFactory.getDatastoreService();

	@Override
	public List<TweeterList> getList()
	{
	    String str="hello"

			//Try to Clear of the List to prevent refresh mess( maybe it helps)
			listoflist.clear();

			//All the entities in this parent keys are listname and their properties are  listitems

			Query query=new Query(ListParentKey.getKey());
			//Each entity is a listname and properties are ids
			List<Entity> zomatolist=datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());  

			Map<String, Object> listmap;

			ArrayList<String> list;

			System.err.println(zomatolist.size());

			for(Entity e:zomatolist)
			{

				listmap=e.getProperties();	//Get all the properties as a map ;)

				//Get all the keys(ids) as a 
				Set<String> listset=listmap.keySet();
				list=new ArrayList(listset);

				//Make a TweeterList Instance
				TweeterList tweeterlist=new TweeterList(e.getKind(),list);
				listoflist.add(tweeterlist);	//Add to our lists of lists :O

			}

			return listoflist;		
	}

	@Override
	public void addList(String listname)
	{
			//For every list we make we make we make a new Key and update our CellBrowser widget
			Key listkey=ListParentKey.getKey();

			//Make a list as a new Entity (all ids-->id name are key to property mappings)
			Entity listentity=new Entity(listname,listkey);
			datastore.put(listentity);		//For now make a  Entity :)
	}

	@Override
	public void addItem(String listname,String item)
	{
			//Add the item to listname
			Query query=new Query(listname,ListParentKey.getKey());

			Entity entity=datastore.prepare(query).asSingleEntity();

			//Add the Item as a property :)
			entity.setProperty(item,"");	//for now we just care about Entity name not the corresponding property
			datastore.put(entity);
	}

	@Override
	public void deleteItem(String listname)
	{
		//Delete the damn list
		//We just have to delete an Entity :)
		Query query=new Query(listname,ListParentKey.getKey());
		Entity entity=datastore.prepare(query).asSingleEntity();

		//Perform Delete!
		datastore.delete(entity.getKey());
	}

	@Override
	public void deleteIds(ArrayList<String> ids)
	{
		//Enumerate on everything and delete the properties (Again can be optimised by just enumerating over the parent) 
		Query query=new Query(ListParentKey.getKey());
		//Each entity is a listname and properties are ids
		List<Entity> zomatolist=datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());

		Map<String, Object> listmap;

		for(int c=0;c<zomatolist.size();c++)
		{
			//Get all the properties of Entity 'e'
			listmap=zomatolist.get(c).getProperties();	//Get all the properties as a map ;)
			Set<String> listset=listmap.keySet();

			//See if one of the ids in this Entiy
			if(listset.contains(ids.get(0))==false) //If this id isnt in this Entity then no other will be :)
				continue;
			else
			{
				for(String s:ids)		//Remove all properties :)
				{
					zomatolist.get(c).removeProperty(s);
				}
				datastore.put(zomatolist.get(c));	//Put back the entity :D
			}
		}
	}


}
