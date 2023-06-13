import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shnatter/src/controllers/ProfileController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/list_text.dart';

// ignore: must_be_immutable
class MainLeftPanel extends StatelessWidget {
  MainLeftPanel({super.key, required this.routerFunction});
  Function routerFunction;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.leftBarWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListText(
            onTap: () => {
              ProfileController()
                  .updateProfile(UserManager.userInfo['userName']),
              routerFunction({
                'router': RouteNames.profile,
                'subRouter': UserManager.userInfo['userName'],
              })
            },
            label: UserManager.userInfo['userName'],
            image: SvgPicture.network(
              'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fprofile.svg?alt=media&token=c40823c5-872b-49b8-8f59-70c7b9314263',
              width: 21,
            ),
          ),
          ListText(
            onTap: () => {
              routerFunction({
                'router': RouteNames.messages,
                'subRouter': '',
              })
            },
            label: 'Messages',
            image: SvgPicture.network(
              'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmessages.svg?alt=media&token=9893a9e0-1f09-4bca-82de-b829ba0f0bb5',
              width: 21,
            ),
          ),
          // ListText(
          //   onTap: () => {
          //     routerFunction({
          //       'router': RouteNames.settings,
          //       'subRouter': '',
          //     })
          //   },
          //   label: 'Settings',
          //   image: SvgPicture.network(
          //     'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fsettings.svg?alt=media&token=adf57926-9cd9-444b-970a-9e4f2c5b34bb',
          //     width: 21,
          //   ),
          // ),
          ListText(
            onTap: () => {
              routerFunction({
                'router': RouteNames.settings,
                'subRouter': RouteNames.settings_token,
              })
            },
            label: 'Shnatter Token',
            image: const Icon(Icons.money, size: 21, color: Colors.grey),
          ),
          UserManager.userInfo['admin'] == 'admin'
              ? ListText(
                  onTap: () => {
                    Navigator.pushReplacementNamed(context, RouteNames.adp),
                  },
                  label: 'Admin Panel',
                  image: SvgPicture.network(
                    'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fshnatter_token.svg?alt=media&token=48ac103d-10fc-4847-943e-33ea5d6281bc',
                    width: 21,
                  ),
                )
              : const SizedBox(),
          const Row(children: [
            Padding(padding: EdgeInsets.only(left: 30.0)),
            Text('FAVOURITES',
                style: TextStyle(
                    color: Color.fromARGB(255, 150, 150, 150), fontSize: 10)),
          ]),
          ListText(
            onTap: () => {
              routerFunction({
                'router': RouteNames.nearby,
              })
            },
            label: 'Near By',
            image: const Icon(Icons.pin_drop, size: 21, color: Colors.grey),
          ),
          ListText(
            onTap: () => {
              routerFunction({
                'router': RouteNames.people,
              })
            },
            label: 'People',
            image: SvgPicture.network(
              'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fpeople.svg?alt=media&token=64d020ea-d767-45da-826e-2c24a989b175',
              width: 21,
            ),
          ),
          ListText(
            onTap: () => {
              routerFunction({
                'router': RouteNames.groups,
              })
            },
            label: 'Groups',
            image: SvgPicture.network(
              'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fgroups.svg?alt=media&token=56ef9dc4-2c1b-4dfd-b945-3439cb5dfe25',
              width: 21,
            ),
          ),
          ListText(
            onTap: () => {
              routerFunction({
                'router': RouteNames.events,
              })
            },
            label: 'Events',
            image: SvgPicture.network(
              'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fevents.svg?alt=media&token=92e4dba9-b601-4289-94f9-99534605a248',
              width: 21,
            ),
          ),
          // ListText(
          //     onTap: () => {},
          //     label: 'Memories',
          //     image:
          //         'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmemories.svg?alt=media&token=a3432e12-3fab-4944-9a4e-3c73adf4f568'),
          const Row(children: [
            Padding(padding: EdgeInsets.only(left: 30.0)),
            Text('EXPLORE',
                style: TextStyle(
                    color: Color.fromARGB(255, 150, 150, 150), fontSize: 10)),
          ]),
          // ListText(
          //     onTap: () => {},
          //     label: 'My Articles',
          //     image:
          //         'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmy_articles.svg?alt=media&token=e98ee341-30f4-4e2d-8797-0e8396c4fada'),

          // ListText(
          //     onTap: () => {},
          //     label: 'Saved Posts',
          //     image:
          //         'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fsaved_posts.svg?alt=media&token=a6950b2b-26ee-4cb8-b1ff-78047383e0de'),
          // ListText(
          //     onTap: () =>
          //         {Navigator.pushReplacementNamed(context, RouteNames.pages)},
          //     label: 'Pages',
          //     image:
          //         'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fpages.svg?alt=media&token=eed0ae72-6faf-4fdc-8581-bf3a99a04fa7'),

          // ListText(
          //     onTap: () => {},
          //     label: 'News',
          //     image:
          //         'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fnews.svg?alt=media&token=c68ab470-dcd6-4c58-9ed6-5e5fc1540110'),
          ListText(
            onTap: () => {
              routerFunction({
                'router': RouteNames.market,
              })
            },
            label: 'Marketplace',
            image: SvgPicture.network(
              'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmarketplace.svg?alt=media&token=cd9adfd0-3db3-4d46-a5fa-7ce8f99016bf',
              width: 21,
            ),
          ),
          ListText(
            onTap: () => {
              routerFunction({
                'router': RouteNames.realEstate,
              })
            },
            label: 'Real estate',
            image: SvgPicture.network(
              'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Freal_estate.svg?alt=media&token=70d45887-6f23-456d-8396-d38287ae8d9e',
              width: 21,
            ),
          ),
          ListText(
            onTap: () => {
              routerFunction({
                'router': RouteNames.products,
              })
            },
            label: 'My Products',
            image: SvgPicture.network(
              'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Fmy_products.svg?alt=media&token=91cdcfb3-cb0a-4061-a19f-b020c61299a0',
              width: 21,
            ),
          ),
          ListText(
            onTap: () => {
              routerFunction({
                'router': RouteNames.liveStreaming,
              })
            },
            label: 'Live Streaming',
            image: Icon(Icons.stream),
          ),
          // ListText(
          //   onTap: () => {
          //     routerFunction({
          //       'router': RouteNames.realEstate,
          //     })
          //   },
          //   label: 'Real estate',
          //   image: SvgPicture.network(
          //     'https://firebasestorage.googleapis.com/v0/b/shnatter-a69cd.appspot.com/o/shnatter-assests%2Fsvg%2Freal_estate.svg?alt=media&token=70d45887-6f23-456d-8396-d38287ae8d9e',
          //     width: 21,
          //   ),
          // ),
        ],
      ),
    );
  }
}
